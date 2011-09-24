module EYCli
  module Command
    class Base
      attr_reader :options

      def run(args)
        @options = options_parser.parse(args)
        invoke
      end

      def options_parser
        EYCli::OptionsParser.new # TODO: Override to extend
      end
    end
  end
end
