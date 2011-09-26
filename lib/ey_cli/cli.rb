module EYCli
  class CLI
    def run(args)
      name = args.shift.downcase
      command = EYCli.command_manager[name]
      unless command
        EYCli.term.say <<-EOF

Command not available: '#{name}'
Try running `ey_cli help' to get more information about the available commands.
EOF
      else
        command.run(args)
      end
    end
  end
end
