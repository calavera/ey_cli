module EYCli
  module Model
    class App < Base
      def self.create(hash)
        base_path = create_path(hash)

        response = EYCli.api.post(base_path, nil, hash)
        new response.body['app']
      rescue Faraday::Error::ClientError => e
        new MultiJson.decode(e.response[:body])
      end

      def self.find_by_repository_uri(repository_uri, collection = all)
        collection.find {|resource| resource.repository_uri == repository_uri}
      end

      private
      def self.create_path(hash)
        account = hash.delete(:account)
        raise Faraday::Error::ClientError, {:body => MultiJson.encode({:errors => {:account => 'Not found'}})} unless account
        (account.class.base_path + '/%s/apps') % account.id
      end
    end
  end
end
