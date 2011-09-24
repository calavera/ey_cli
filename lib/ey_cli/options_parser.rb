module EYCli
  class OptionsParser
    require 'optparse'

    attr_reader :options

    def self.parse(args)
      new.parse(args)
    end

    def initialize(options = {})
      @options = options
    end

    def parse(args)
      options_parser.parse!(args)
      options
    rescue OptionParser::InvalidOption => e
      p e, options_parser
      exit 1
    end

    def options_parser
      ::OptionParser.new do |opts|
        opts.banner = 'ey_cli options:'
        opts.separator ' '

        opts.on('-v', '--version', 'display the current version') do
          puts "ey_cli #{EYCli::VERSION}"
          exit
        end

        opts.on('-a', '--account ACCOUNT_NAME') do |account|
          options[:account] = account
        end

        opts.on('-p', '--app APP_NAME') do |app|
          options[:app] = app
        end

        opts.on('-e', '--environment ENVIRONMENT_NAME') do |environment|
          options[:environment] = environment
        end
      end
    end
  end
end
