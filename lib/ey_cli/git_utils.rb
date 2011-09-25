module EYCli
  module GitUtils
    require 'grit'

    def git_repository?(base)
      File.exist?(File.join(base, '.git'))
    end

    def fetch_repository(base)
      Grit::Repo.new(base).config['remote.origin.url']
    end
  end
end
