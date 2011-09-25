module EYCli
  module Command
    class CreateEnv < Base
      def initialize
        @apps         = EYCli::Controller::Apps.new
        @environments = EYCli::Controller::Environments.new
      end

      def invoke
        app = @apps.fetch_account(nil, options)
        @environments.create(app, options)
      end

      def help
        "Create environments"
      end
    end
  end
end
