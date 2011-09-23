require 'rspec'

$LOAD_PATH << '../lib'
require 'ey_cli'
require 'webmock/rspec'
require 'multi_json'

EYCli.api 'http://example.com' # use example.com as an endpoint

RSpec.configure

def to_json(hash)
  MultiJson.encode(hash)
end
