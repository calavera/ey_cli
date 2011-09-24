module EYCli
  module Controller
    class Accounts
      def fetch_account(name = nil)
        if name
          EYCli::Model::Account.find_by_name(name) rescue nil
        else
          accounts = EYCli::Model::Account.all
          return accounts.first if accounts.empty? || accounts.size == 1

          name = EYCli.term.choose_resource(accounts,
                  "I don't know which account you want to use.",
                  'Please select an account:')
          EYCli::Model::Account.find_by_name(name, accounts)
        end
      end
    end
  end
end
