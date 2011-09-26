module EYCli
  module Command
    class CreateEnv < Base
      def initialize
        @apps         = EYCli::Controller::Apps.new
        @environments = EYCli::Controller::Environments.new
      end

      def invoke
        app = @apps.fetch_app(nil, options)
        @environments.create(app, options)
      end

      def help
        <<-EOF

Usage: ey_cli create_env
Note: it takes the information from the current directory. It will guide you if it cannot reach all that information.
EOF
      end
    end
  end
end
