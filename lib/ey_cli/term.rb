module EYCli
  class Term
    require 'highline'

    attr_reader :terminal

    def initialize(input = $stdin, output = $stdout)
      HighLine.color_scheme = HighLine::SampleColorScheme.new
      @terminal = HighLine.new(input, output)
    end

    def choose_resource(collection, message, prompt)
      say(message)

      terminal.choose do |menu|
        menu.index = :number
        menu.index_suffix = ' ~> '
        menu.prompt = prompt

        collection.each do |resource|
          menu.choice resource.name
        end
      end
    end

    def say(message)
      terminal.say(message)
    end

    def error(message)
      terminal.say(%Q{<%= color("#{message}", :error)%>})
    end

    def warning(message)
      terminal.say(%Q{<%= color("#{message}", :warning)%>})
    end

    def success(message)
      terminal.say(%Q{<%= color("#{message}", :debug)%>})
    end

    def print_errors(errors, message)
      error(message)
      errors.each do |key, value|
        alert = value.respond_to?(:join) ? value.join(',') : value.inspect
        error("\t- #{key}: #{alert}")
      end
    end

    def ask(prompt, protected_filed = false)
      if protected_filed
        terminal.ask(prompt) {|q| q.echo = '*'}
      else
        terminal.ask(prompt) {|q| q.readline = true}
      end
    end
  end
end
