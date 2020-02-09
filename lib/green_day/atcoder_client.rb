# frozen_string_literal: true

require 'faraday'
require 'faraday-cookie_jar'
require 'webrick/cookie'
require 'nokogiri'

module GreenDay
  class AtcoderClient
    ATCODER_ENDPOINT = 'https://atcoder.jp'
    COOKIE_DB = 'cookie-store'
    attr_accessor :client, :cookie_jar

    def initialize
      @cookie_jar = create_or_load_cookie_jar
      @client = Faraday.new(url: ATCODER_ENDPOINT) do |builder|
        builder.use :cookie_jar, jar: cookie_jar
        builder.request :url_encoded
        builder.adapter :net_http
      end
    end

    def contest_exist?(contest_name)
      res = client.get("contests/#{contest_name}")
      res.status == 200
    end

    def fetch_task_codes(contest)
      body = get_parsed_body("contests/#{contest.name}/tasks")

      # 3問だったら<tbody>の中に<tr>が3 * 2個 </tbody> が1mh個
      tasks_size = ((body.at('tbody').children.size - 1) / 2.0).ceil
      ('A'..'Z').to_a.shift(tasks_size)
    end

    def fetch_inputs_and_outputs(contest, task)
      path = "contests/#{contest.name}/tasks/#{contest.name}_#{task.code.downcase}"
      body = get_parsed_body(path)
      samples = body.css('.lang-ja > .part > section > pre').map { |e| e.children.text }

      imputes = []
      outputs = []
      samples.each_with_index do |sample, i|
        if i.even?
          imputes << sample
        else
          outputs << sample
        end
      end

      [imputes, outputs]
    end

    def login(username, password)
      csrf_token = obtain_atcoder_csrf_token

      client.post('/login',
                  username: username,
                  password: password,
                  csrf_token: csrf_token)

      unless login_succeed?
        # TODO: TBD
        raise Error, CGI.unescape(select_flash_cookie.value)
      end

      cookie_jar.save(COOKIE_DB)
    end

    private

    def create_or_load_cookie_jar
      jar = HTTP::CookieJar.new
      jar.load(COOKIE_DB) if File.exist?(COOKIE_DB)
      jar
    end

    def obtain_atcoder_csrf_token
      get_login_responce = client.get('/login')
      login_html = Nokogiri::HTML.parse(get_login_responce.body)
      login_html.at('input[name="csrf_token"]')['value']
    rescue StandardError
      raise Error, 'cant get_csrf_token'
    end

    def login_succeed?
      flash_cookie = select_flash_cookie
      flash_cookie.value.include?('Welcome')
    end

    def select_flash_cookie
      cookie_jar.store.instance_variable_get(:@jar)['atcoder.jp']['/']['REVEL_FLASH']
    end

    def get_parsed_body(path)
      res = client.get(path)
      Nokogiri::HTML.parse(res.body)
    end
  end
end
