module EYCli
  class Api
    require 'yaml'
    require 'faraday_middleware'
    require 'faraday_stack'

    attr_reader :endpoint

    def initialize(endpoint = nil)
      @endpoint = endpoint || 'https://cloud.engineyard.com/api/v2/'
      @api_token = read_token # FIXME: Ask login and password the first time
    end

    def read_token(file = nil)
      file ||= ENV['EYRC'] || File.expand_path("~/.eyrc")
      return false unless File.exists?(file)

      data = YAML.load_file(file)
      data["api_token"] if data
    end

    def get(path, params = {}, headers = {})
      request(path, {:method => :get}.merge(params), headers)
    end

    def post(path, body, params = {}, headers = {})
      request(path, {:method => :post, :body => body}.merge(params), headers)
    end

    def put(path, body, params = {}, headers = {})
      request(path, {:method => :put, :body => body}.merge(params), headers)
    end

    def delete(path, params = {}, headers = {})
      request(path, {:method => :delete}.merge(params), headers)
    end

    def request(path, params = {}, headers = {})
      http_method = params.delete(:method).to_s.downcase
      http_body   = params.delete(:body)

      connection.send(http_method) do |req|
        req.path = path
        req.params.merge! params
        req.headers.merge! headers

        req.headers["X-EY-Cloud-Token"] = @api_token
        req.body = http_body if http_body
      end
    end

    def connection
      @connection ||= Faraday::Connection.new(:url => endpoint) do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::ParseJson
        builder.use FaradayStack::FollowRedirects
        builder.response :raise_error
      end
    end
  end
end
