module EYCli
  module AuthHelper
    def self.extended(example_group)
      example_group.use_credentials(example_group)
    end

    def self.included(example_group)
      example_group.extend self
    end

    def mock_credentials
  rc = File.expand_path('../fake_rc', __FILE__)

  File.open(rc, 'w') do |f| f.write <<-EOF
---
  api_token: fake_token
EOF
  end
  ENV['EYRC'] = rc
end

    def use_credentials(describe_block)
      describe_block.before :each do
        mock_credentials
      end
    end
  end
end
