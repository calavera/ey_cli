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
        "Create applications"
      end
    end
  end
end
