module EYCli
  module Controller
    class Apps
      def create(account, base = Dir.pwd)
        if File.exist?(File.join(base, '.git'))
          app = EYCli::Model::App.create({
            :account         => account,
            'app[name]'            => File.basename(base),
            'app[app_type_id]'     => fetch_type(base).to_s,
            'app[repository_uri]'  => fetch_repository(base)
          })

          if app.errors?
            EYCli.term.print_errors(app.errors, "App creation failed:")
          else
            EYCli.term.success("App created successfully")
          end
        else
          EYCli.term.error("Not a git repository: #{base}")
        end
      end

      def fetch_type(base)
        if File.exist?(File.join(base, 'config.ru')) && File.exist?(File.join(base, 'config', 'environment.rb'))
          :rails3
        elsif File.exist?(File.join(base, 'config', 'environment.rb'))
          :rails2
        elsif File.exist?(File.join(base, 'config.ru'))
          :rack
        else # Raise unkown application type?
          :rails3
        end
      end

      def fetch_repository(base)
        `git config -f #{base}/.git/config --get-regexp 'remote.origin.url'`.split.last
      end
    end
  end
end
