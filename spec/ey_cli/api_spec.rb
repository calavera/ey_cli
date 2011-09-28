require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe EYCli::Api do
  subject { EYCli::Api.new('http://example.com') }

  context "reading the auth token from the file" do
    it "returns nil if the file doesn't exist" do
      subject.read_token('fake_file').should be_nil
    end

    it "returns nil if the file is empty" do
      File.open('fake_file', 'w')
      subject.read_token('fake_file').should be_nil
    end

    it "returns the token in the root if there is no token for the endpoint" do
     File.open('fake_file', 'w') do |f| 
      f.write <<-EOF
---
  api_token: root_api_token
EOF
    end

     subject.read_token('fake_file').should == 'root_api_token'
    end

    it "returns the token for the endpoint if exists" do
     File.open('fake_file', 'w') do |f| 
      f.write <<-EOF
---
  api_token: root_api_token
  http://example.com:
    api_token: example_com_api_token
EOF
    end

     subject.read_token('fake_file').should == 'example_com_api_token'
    end
  end

  context "saving the auth token" do
    def fake_rc_file
      File.read('fake_file').gsub(/\s*/m, '')
    end

    it "stores the token under the enpoint" do
      subject.save_token('new_token', 'fake_file')
      fake_rc_file.should == '---http://example.com:api_token:new_token'
    end

    it "adds it to the file if already existed" do
      File.open('fake_file', 'w') {|f| f.write("---\n  api_token: root_token") }
      subject.save_token('new_token', 'fake_file')
      fake_rc_file.should == '---api_token:root_tokenhttp://example.com:api_token:new_token'
    end
  end

  context "fetching the token from the terminal" do
    it "sends the user credentials to the api" do
      EYCli.term.should_receive(:ask).with('Email: ').and_return('foo@foo.com')
      EYCli.term.should_receive(:ask).with('Password: ', true).and_return('fooooo')

      stub_request(:post, "http://example.com/authenticate?email=foo@foo.com&password=fooooo").
         to_return(:status => 200, :body => to_json(:api_token => 'foo_token'))

      ENV['EYRC'] = 'fake_file'
      subject.fetch_token.should == 'foo_token'
    end
  end
end
