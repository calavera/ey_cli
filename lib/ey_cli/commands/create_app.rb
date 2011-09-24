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
        # TODO: print help stuff
      end
    end
  end
end
