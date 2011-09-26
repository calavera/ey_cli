module EYCli
  module Command
    class CreateApp < Base
      def initialize
        @accounts = EYCli::Controller::Accounts.new
        @apps     = EYCli::Controller::Apps.new
      end

      def invoke
        account = @accounts.fetch_account(options[:account])
        @apps.create(account)
      end

      def help
        <<-EOF

Usage: ey_cli create_app
Note: it takes its arguments(name, git repository and application type) from the base directory.
EOF
      end
    end
  end
end
