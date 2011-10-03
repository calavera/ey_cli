module EYCli
  module Command
    class Deploy < Base
      def initialize
        @apps = EYCli::Controller::Apps.new
        @environments = EYCli::Controller::Environments.new
      end

      def invoke
        app = @apps.fetch_app(nil, options)
        @environments.deploy(app, options)
      end

      def help
        <<-EOF

Usage: ey_cli deploy
Note: takes the application's information from the current directory. It will guide you if it cannot reach that information.
EOF
      end
    end
  end
end
