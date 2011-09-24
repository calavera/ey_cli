module EYCli
  class CLI
    def initialize
      @command_manager = CommandManager.new
    end

    def run(args)
      command = @command_manager[args.shift.downcase]
      unless command
        # command not found
      else
        command.run(args)
      end
    end
  end
end
