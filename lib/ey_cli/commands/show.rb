module EYCli
  module Command
    class Show < Base
      def initialize
        @apps = EYCli::Controller::Apps.new
      end

      def invoke
        app = @apps.fetch_app(nil, options)
        if app
          EYCli.term.say info(app)
          EYCli.term.say(status(app)) if app.environments
        end
      end

      def info(app)
        %Q{
#{app.name}:
  - Info:
     + git repository: #{app.repository_uri}}
      end

      def status(app)
        status = %Q{

  - Status per environment:}
        app.environments.each do |env|
          status << %Q{
     + #{env.name}:
        - environment: #{env.framework_env}
        - stack:       #{env.app_server_stack_name}
        - status:      #{env.instance_status}}

          if env.instances
            status << %Q{
        - instances:}
            env.instances.each do |instance|
              status << %Q{
           + #{instance.role}:
              - Amazon ID: #{instance.amazon_id}
              - status:    #{instance.status}}
            end
          end
        end
        status
      end

      def help
        <<-EOF

Show information and status of an application. If a name is not supplied it assumes the current directory as application base.
Usage: `ey_cli show app_name'
EOF
      end

      def options_parser
        ShowParser.new
      end

      class ShowParser
        def parse(args)
          name = args.empty? ? nil : args.shift.downcase
          {:app_name => name}
        end
      end
    end
  end
end
