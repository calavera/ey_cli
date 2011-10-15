module EYCli
  module Command
    class Accounts < Base
      def initialize
        @accounts = EYCli::Controller::Accounts.new
      end

      def invoke
        accounts = @accounts.fetch_accounts.map {|a| "  - #{a.name}"}.join("\n")
        EYCli.term.say <<-EOF

Available accounts:
#{accounts}
EOF

      end

      def help
        <<-EOF
Usage: ey_cli accounts
Note: it shows the accounts that belong to you and also the ones that you are collaborating with.
EOF
      end
    end
  end
end
