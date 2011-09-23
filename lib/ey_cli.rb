module EYCli
  VERSION = '0.1.0'

  require 'hashie/mash'

  require 'ey_cli/api'
  require 'ey_cli/options_parser'
  require 'ey_cli/command_manager'
  require 'ey_cli/cli'
  require 'ey_cli/smarty_parser'

  require 'ey_cli/models/base'
  require 'ey_cli/models/account'
  require 'ey_cli/models/app'
  require 'ey_cli/models/environment'

  def self.api(endpoint = nil)
    @api ||= Api.new(endpoint)
  end
end
