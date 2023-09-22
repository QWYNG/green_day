# frozen_string_literal: true

require 'faraday'
require 'faraday-cookie_jar'
require 'nokogiri'

module GreenDay
  class AtcoderClient
    ATCODER_ENDPOINT = 'https://atcoder.jp'
    COOKIE_FILE_NAME = '.cookie-store'
    attr_reader :client, :cookie_jar

    def initialize
      @cookie_jar = create_or_load_cookie_jar
      @client = Faraday.new(url: ATCODER_ENDPOINT) do |builder|
        builder.use :cookie_jar, jar: cookie_jar
        builder.request :url_encoded
        builder.adapter :net_http
      end
    end

    def get_parsed_body(path)
      res = client.get(path)
      Nokogiri::HTML.parse(res.body)
    end

    def login(username, password)
      csrf_token = obtain_atcoder_csrf_token

      client.post('/login',
                  username:,
                  password:,
                  csrf_token:)

      unless login_succeed?
        ## ex error:Username or Password is incorrect
        raise Error, CGI.unescape(flash_cookie.value).split('.').shift
      end

      cookie_jar.save(COOKIE_FILE_NAME)
    end

    private

    def create_or_load_cookie_jar
      jar = HTTP::CookieJar.new
      if File.exist?(COOKIE_FILE_NAME)
        jar.load(COOKIE_FILE_NAME)
      elsif File.exist?('cookie-store')
        warn 'cookie-store needs rename .cookie-store'
        jar.load('cookie-store')
      end

      jar
    end

    def obtain_atcoder_csrf_token
      get_login_response = client.get('/login')
      login_html = Nokogiri::HTML.parse(get_login_response.body)
      login_html.at('input[name="csrf_token"]')['value']
    rescue StandardError
      raise Error, 'cant get_csrf_token'
    end

    def login_succeed?
      flash_cookie.value.include?('Welcome')
    end

    def flash_cookie
      @flash_cookie ||= cookie_jar.cookies("#{ATCODER_ENDPOINT}/login").find do |cookie|
        cookie.name == 'REVEL_FLASH'
      end
    end
  end
end
