module EYCli
  module Command
    class Help < Base

      def invoke
        if name = options[:command_name]
          if name == 'commands'
            print_commands
          else
            print_command_help(name)
          end
        else
          EYCli.term.say(help)
        end
      end

      def print_command_help(name)
        command = EYCli.command_manager[name]
        command_help = command.help
        if command_help
          EYCli.term.say(command.help)
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
run `ey_cli help commands' to see the list of available commands
run `ey_cli help [COMMAND_NAME]' to see the help for a specific command
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
