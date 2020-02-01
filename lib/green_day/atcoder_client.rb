# frozen_string_literal: true

require 'faraday'
require 'faraday-cookie_jar'
require 'webrick/cookie'
require 'nokogiri'

module GreenDay
  class AtcoderClient
    ATCODER_ENDPOINT = 'https://atcoder.jp'
    attr_accessor :client

    def initialize
      @client = Faraday.new(url: ATCODER_ENDPOINT) do |builder|
        builder.use :cookie_jar
        builder.request :url_encoded
        builder.adapter :net_http
      end
    end

    def login(username, password)
      csrf_token = obtain_atcoder_csrf_token

      res = client.post('/login',
                        username: username,
                        password: password,
                        csrf_token: csrf_token)

      flash_cookie, session_cookie = cookies(res)

      unless login_succeed?(flash_cookie)
        # TODO: TBD
        raise Error, CGI.unescape(flash_cookie.value)
      end

      store_cookie(session_cookie)
    end


    private

    def obtain_atcoder_csrf_token
      get_login_responce = client.get('/login')
      login_html = Nokogiri::HTML.parse(get_login_responce.body)
      login_html.at('input[name="csrf_token"]')['value']
    rescue _
      raise Error, 'cant get_csrf_token'
    end

    def login_succeed?(flash_cookie)
      flash_cookie.value.include?('Welcome')
    end

    def cookies(res)
      WEBrick::Cookie.parse_set_cookies(res.headers['set-cookie'])
    end

    def store_cookie(cookie)
      IO.write('cookie-data', cookie.to_s)
    end
  end
end
