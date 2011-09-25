module EYCli
  module Controller
    class Environments
      def create(app, options = {})
        framework_env = options[:framework_env] || 'production'
        env_name      = options[:env_name] || "#{app.name}_#{framework_env}"

        env = EYCli::Model::Environment.create({
          :app                         => app,
          'environment[name]'          => env_name,
          'environment[framework_env]' => framework_env
        })

        if env.errors?
          EYCli.term.print_errors(env.errors, "I couldn't create the environment:")
        else
          EYCli.term.success('Environment created successfully')
        end
        env
      end
    end
  end
end
