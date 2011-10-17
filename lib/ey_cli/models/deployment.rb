module EYCli
  module Model
    class Deployment < Base
      base_path 'apps/%s/environments/%s/deployments'

      def self.deploy_path(app, environment)
        collection_path([app.id, environment.id]) + '/deploy'
      end

      def self.last_deployment(app, environment)
        find(app.id, environment.id, 'last')
      rescue Faraday::Error::ClientError => e # there is no last deployment if we never deployed the app
        raise e unless e.response[:status] == 404
        nil
      end
    end
  end
end
