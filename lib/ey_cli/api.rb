module EYCli
  class Api
    require 'yaml'
    require 'faraday_middleware'
    require 'faraday_stack'

    attr_reader :endpoint

    def initialize(endpoint = nil)
      @endpoint = endpoint || ENV['EY_ENDPOINT'] || 'https://cloud.engineyard.com/api/v2/'
    end

    def read_token(file = nil)
      file ||= ENV['EYRC'] || File.expand_path("~/.eyrc")
      return nil unless File.exists?(file)

      if data = YAML.load_file(file)
        (data[endpoint] && data[endpoint]['api_token']) || data['api_token']
      end
    end

    def fetch_token(times = 3)
      EYCli.term.say("I don't know who you are, please log in with your Engine Yard Cloud credentials.")
      begin
        email    = EYCli.term.ask("Email: ")
        password = EYCli.term.ask("Password: ", true)

        response = post("authenticate", nil, { :email => email, :password => password }, {}, false)
        save_token(response.body['api_token'])
      rescue Faraday::Error::ClientError
        EYCli.term.warning "Invalid username or password; please try again."
        if (times -= 1) > 0
          retry
        else
          exit 1
        end
      end
    end

    def save_token(token, file = nil)
      file ||= ENV['EYRC'] || File.expand_path("~/.eyrc")

      data = File.exists?(file) ? YAML.load_file(file) : {}
      data[endpoint] = {"api_token" => token}

      File.open(file, "w"){|f| YAML.dump(data, f) }
      token
    end

    def get(path, params = {}, headers = {})
      request(path, {:method => :get}.merge(params), headers)
    end

    def post(path, body, params = {}, headers = {}, auth = true)
      request(path, {:method => :post, :body => body}.merge(params), headers, auth)
    end

    def put(path, body, params = {}, headers = {})
      request(path, {:method => :put, :body => body}.merge(params), headers)
    end

    def delete(path, params = {}, headers = {})
      request(path, {:method => :delete}.merge(params), headers)
    end

    def request(path, params = {}, headers = {}, auth = true)
      http_method = params.delete(:method).to_s.downcase
      http_body   = params.delete(:body)
      @auth_token ||= read_token || fetch_token if auth

      if ENV['EY_DEBUG']
        puts %Q{-- DEBUG --
     PATH : #{path}
   PARAMS : #{params.inspect}
  HEADERS : #{headers.inspect}
}
      end

      connection.send(http_method) do |req|
        req.path = path
        req.params.merge! params
        req.headers.merge! headers

        req.headers["X-EY-Cloud-Token"] = @auth_token if auth
        req.body = http_body if http_body
      end
    rescue Faraday::Error::ClientError => e
      raise e unless e.response[:status] == 401
      @auth_token = fetch_token if auth
      params[:method] = http_method
      params[:body]   = http_body
      retry
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
