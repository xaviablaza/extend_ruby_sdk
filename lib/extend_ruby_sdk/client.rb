# frozen_string_literal: true

require 'httparty'

module ExtendRubySdk
  class Client
    SANDBOX_API_ENDPOINT = "https://api-demo.helloextend.com"
    API_ENDPOINT = "https://api.helloextend.com"

    def initialize(sandbox: false, client_ip: '')
      @sandbox = sandbox
      @client_ip = client_ip
    end

    def get(path, headers = default_get_headers)
      HTTParty.get(url(path), { headers: headers })
    end

    def post(path, body = {}, headers = default_post_headers, query: {})
      HTTParty.post(url(path), { body: body.to_json, headers: headers, query: query })
    end

    def put(path, body = {}, headers = default_put_headers)
      HTTParty.put(url(path), { body: body.to_json, headers: headers })
    end

    def delete(path, headers = default_delete_headers)
      HTTParty.delete(url(path), { headers: headers })
    end

    private

    def base_url
      return SANDBOX_API_ENDPOINT if @sandbox

      API_ENDPOINT
    end

    def url(path)
      "#{base_url}/#{path}"
    end

    def access_token_key_name
      'X-Extend-Access-Token'
    end

    def access_token
      ExtendRubySdk.configuration.access_token
    end

    def default_get_headers
      {
        'Content-Type' => 'application/json',
        access_token_key_name => access_token,
        'Accept' => 'application/json; version=2021-04-01',
        'X-Extend-Client-IP' => @client_ip
      }.reject { |_k, v| v.blank? }
    end

    def default_post_headers
      default_get_headers
    end

    def default_put_headers
      default_get_headers
    end

    def default_delete_headers
      default_get_headers
    end
  end
end
