module EYCli
  module GitUtils
    def git_repository?(base)
      File.exist?(File.join(base, '.git'))
    end

    def fetch_repository(base)
      config = File.join(base, '.git', 'config')
      `git config -f #{config} --get 'remote.origin.url'`.chomp
    end
  end
end
