require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Model::App do
  context ".create" do
    it "return an error if it doesn't find the account" do
      app = EYCli::Model::App.create({})
      app.errors?.should be_true
      app.errors.keys.should include('account')
    end

    it "return an error if a model validation fails" do
      account = EYCli::Model::Account.new({:id => 1})
      stub_request(:post, 'http://example.com/accounts/1/apps?app[name]=foo').
        to_return(:status => 422, :body => to_json({:errors => {:name => ['App name already exists']}}))

      app = EYCli::Model::App.create({:account => account, 'app[name]' => 'foo'})
      app.errors?.should be_true
      app.errors.keys.should include('name')
    end

    it "returns the new app when it's successful" do
      account = EYCli::Model::Account.new({:id => 1})
      expected = EYCli::Model::App.new({:id => 1, :name => 'foo'})
      stub_request(:post, 'http://example.com/accounts/1/apps?app[name]=foo').
        to_return(:status => 201, :body => to_json(:app => expected))

      app = EYCli::Model::App.create({:account => account, 'app[name]' => 'foo'})
      app.should == expected
    end

    context '.find_by_repository_uri' do
      let(:app1) { EYCli::Model::App.new(:id => 1, :repository_uri => 'git@foo.com') }
      let(:app2) { EYCli::Model::App.new(:id => 2, :repository_uri => 'git@bar.com') }
      before do
        stub_request(:get, 'http://example.com/apps').
          to_return(:status => 200, :body => to_json(:apps => [app1, app2]))
      end

      it "returns an instance of App if it finds it" do
        app = EYCli::Model::App.find_by_repository_uri('git@bar.com')
        app.should == app2
      end

      it "returns nil when it cannot find the app" do
        app = EYCli::Model::App.find_by_repository_uri('foo@bar.com')
        app.should be_nil
      end
    end
  end
end
