module EYCli
  class Term
    require 'highline'

    attr_reader :terminal

    def initialize(input = $stdin, output = $stdout)
      @input, @output = input, output
      @terminal = HighLine.new(input, output)
    end

    def choose_resource(collection, prompt, message = nil)
      terminal.say(message) if message

      choice = terminal.choose do |menu|
        menu.index = :number
        menu.index_suffix = ' ~> '
        menu.prompt = prompt

        menu.choices collection.map {|resource| resource.name}
      end

      collection.select {|resource| resource.name == choice}.first
    end
  end
end
