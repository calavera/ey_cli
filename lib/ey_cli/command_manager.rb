module EYCli
  class CommandManager
    attr_reader :commands
    def initialize
      @commands = {}
      register_command :help
      register_command :create_app
    end

    def register_command(name)
      commands[name] = false
    end

    def [](name)
      command_name = name.to_sym
      return nil unless commands.key?(command_name)
      commands[command_name] = load_command(command_name) unless commands[command_name]
    end

    def load_command(name)
      const_name = name.to_s.capitalize.gsub(/_(.)/) { $1.upcase }
      if EYCli::Command.const_defined?(const_name)
        EYCli::Command.const_get(const_name).new
        # TODO: else require and retry (PLUGINS)
      end
    end
  end
end
