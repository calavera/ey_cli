module EYCli
  module Command
    class Help < Base

      def invoke
        if name = options[:command_name]
          command = EYCli.command_manager[name]
          command_help = command.help
          if command_help
            EYCli.term.say(command.help)
          else
            EYCli.term.say("help not available for command: '#{name}'")
          end
        else
          EYCli.term.say(help)
        end
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
