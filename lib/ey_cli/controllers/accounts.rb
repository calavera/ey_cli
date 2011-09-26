module EYCli
  module Controller
    class Accounts
      def fetch_account(name = nil)
        accounts = fetch_accounts
        if name
          EYCli::Model::Account.find_by_name(name, accounts) rescue nil
        else
          return accounts.first if accounts.empty? || accounts.size == 1

          name = EYCli.term.choose_resource(accounts,
                  "I don't know which account you want to use.",
                  'Please, select an account:')
          EYCli::Model::Account.find_by_name(name, accounts)
        end
      end

      def fetch_accounts
        EYCli::Model::Account.all.sort_by {|account| account.name}
      end
    end
  end
end
