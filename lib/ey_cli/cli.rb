module EYCli
  class CLI
    def run(args)
      if args.size == 0
        EYCli.term.say <<-EOF
USAGE: ey_cli COMMAND

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
        exit 1
      end
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
