module EYCli
  class CLI
    def run(args)
      command = EYCli.command_manager[args.shift.downcase]
      unless command
        # command not found
      else
        command.run(args)
      end
    end
  end
end
