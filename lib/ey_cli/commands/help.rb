module EYCli
  module Command
    class Help < Base

      def invoke
        name = options[:command_name] || 'help'
        if name == 'commands'
          print_commands
        else
          print_command_help(name)
        end
      end

      def print_command_help(name)
        command = EYCli.command_manager[name]
        if command_help = (command and command.help)
          EYCli.term.say(command_help)
        else
          EYCli.term.say("help not available for command: '#{name}'")
        end
      end

      def print_commands
        EYCli.term.say("available commands:")
        command_names = EYCli.command_manager.commands.keys.map {|name| "- #{name}"}.sort
        EYCli.term.say("\t" + command_names.join("\n\t"))
      end

      def options_parser
        HelpParser.new
      end

      def help
        <<-EOF

Usage: ey_cli command [args]
Try `ey_cli help commands' to list the available commands.
Try `ey_cli help [command]' for more information about a command.

Currently available commands:

  General info
    accounts                     List the accounts associated to a user.
    console                      Start an interactive session to use ey_cli.
    help                         Show commands information.

  Applications
    apps                         List the applications associated to a user.
    create_app                   Create a new application. It takes the information from the current directory.
    show                         Show information and status of an application.

  Environments
    create_env                   Create a new environment for an application.
    deploy                       Run a deploy for an application.
EOF
      end

      class HelpParser
        def parse(args)
          {:command_name => args.shift}
        end
      end
    end
  end
end
