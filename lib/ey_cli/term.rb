module EYCli
  class Term
    require 'highline'

    attr_reader :terminal

    def initialize(input = $stdin, output = $stdout)
      HighLine.color_scheme = HighLine::SampleColorScheme.new
      @terminal = HighLine.new(input, output)
    end

    def choose_resource(collection, message, prompt)
      terminal.say(message)

      terminal.choose do |menu|
        menu.index = :number
        menu.index_suffix = ' ~> '
        menu.prompt = prompt

        menu.choices collection.map {|resource| resource.name}
      end
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
  end
end
