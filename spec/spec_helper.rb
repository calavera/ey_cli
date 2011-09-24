require 'rspec'

$LOAD_PATH << '../lib'
require 'ey_cli'
require 'webmock/rspec'
require 'multi_json'
require 'stringio'


# Setup for specs

EYCli.api 'http://example.com' # use example.com as an endpoint

$stdin_test = StringIO.new
$stdout_test = StringIO.new

EYCli.term($stdin_test, $stdout_test) # use fake buffers as input and output

RSpec.configure do |config|
  config.before(:each) do
    $stdin_test = StringIO.new
    $stdout_test = StringIO.new
  end
end

# Helper methods

def to_json(hash)
  MultiJson.encode(hash)
end
