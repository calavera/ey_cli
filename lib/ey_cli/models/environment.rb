module EYCli
  module Model
    class Environment < Base
      base_path 'apps/%s/environments'

      def self.create_path(hash)
        app = hash.delete(:app)
        raise Faraday::Error::ClientError, {:body => MultiJson.encode({:errors => {:app => 'Not found'}})} unless app
        base_path % app.id
      end

    end
  end
end
