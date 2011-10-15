module EYCli
  module Command
    class Apps < Base
      def initialize
        @apps = EYCli::Controller::Apps.new
      end

      def invoke
        apps = @apps.fetch_apps.map {|a| "  - #{a.name}"}.join("\n")
        EYCli.term.say <<-EOF
Available applications:
#{apps}
EOF
      end

      def help
        <<-EOF
List the applications created under your account and the accounts you are collaborating with.
Usage: ey_cli apps
EOF
      end
    end
  end
end
