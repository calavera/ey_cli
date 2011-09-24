module EYCli
  module Controller
    class Accounts
      def fetch_account(name = nil)
        if name
          EYCli::Model::Account.find_by_name(name) rescue nil
        else
          accounts = EYCli::Model::Account.all
          return accounts.first if accounts.empty? || accounts.size == 1

          EYCli.term.choose_resource(accounts,
                                   'Please select an account:',
                                    "I don't know which account you want to use.")
        end
      end
    end
  end
end
