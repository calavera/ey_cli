module EYCli
  VERSION = '0.1.0'
  
  require 'hashie/mash'

  require 'ey_cli/api'
  require 'ey_cli/options_parser'
  require 'ey_cli/cli'
  require 'ey_cli/smarty_parser'

  require 'ey_cli/model/base'
  require 'ey_cli/model/account'
  require 'ey_cli/model/app'
  require 'ey_cli/model/environment'

  def self.api(endpoint = nil)
    @api ||= Api.new(endpoint)
  end
end
