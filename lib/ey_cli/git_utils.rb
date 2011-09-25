module EYCli
  module GitUtils
    require 'grit'

    def fetch_repository(base)
      Grit::Repo.new(base).config['remote.origin.url']
    end
  end
end
