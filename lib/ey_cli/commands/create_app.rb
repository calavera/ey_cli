module EYCli
  module Command
    class CreateApp < Base
      def initialize
        @accounts = EYCli::Controller::Accounts.new
        @apps     = EYCli::Controller::Apps.new
        @envs     = EYCli::Controller::Environments.new
      end

      def invoke
        account = @accounts.fetch_account(options.delete(:account))
        app = @apps.create(account, Dir.pwd, options)
        if app && !options[:no_env]
          @envs.create(app, @envs.fill_create_env_options(options))
        end
        app
      end

      def help
        <<-EOF

It takes its arguments(name, git repository and application type) from the base directory.
Usage: ey_cli create_app

Options:
       --account name             Name of the account to add the application to.
       --name name                Name of the app.
       --git uri                  Git repository uri.
       --type type                Application type, either rack, rails2 or rails3.
       --env_name name            Name of the environment to create.
       --framework_env env        Type of the environment (production, staging...).
       --url url                  Domain name for the app. It accepts comma-separated values.
       --app_instances number     Number of application instances.
       --db_instances number      Number of database slaves.
       --solo                     A single instance for application and database.
       --no_env                   Prevent to not create a default environment.
EOF
      end

      def options_parser
        AppParser.new
      end

      class AppParser
        require 'slop'

        def parse(args)
          opts = Slop.parse(args, {:multiple_switches => false}) do
            on :account, true
            on :name, true
            on :git, true
            on :type, true
            on :env_name, true
            on :framework_env, true
            on :url, true
            on :app_instances, true, :as => :integer
            on :db_instances, true, :as => :integer
            #on :util_instances, true, :as => :integer # FIXME: utils instances are handled differently
            on :solo, false, :default => false
            on :no_env, false, :default => false
          end
          opts.to_hash
        end
      end
    end
  end
end
