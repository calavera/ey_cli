require 'rspec'

$LOAD_PATH << '../lib'
require 'ey_cli'
require 'webmock/rspec'
require 'fakefs/spec_helpers'
require 'stringio'
require 'auth_helper'

# Setup for specs

EYCli.api 'http://example.com' # use example.com as an endpoint

$stdin_test = StringIO.new
$stdout_test = StringIO.new

EYCli.term($stdin_test, $stdout_test) # use fake buffers as input and output


RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
  config.include EYCli::AuthHelper
end

# Helper methods

def to_json(hash)
  MultiJson.encode(hash)
end
