require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Model::Environment do
  context "creating the resource path" do
    let(:clazz) { EYCli::Model::Environment }
    it "raises an error when the app is not into the parameters hash" do
      lambda { clazz.create_collection_path({}) }.should raise_error
    end

    it "creates the resource path using the application id" do
      app = EYCli::Model::App.new(:id => 1)
      path = clazz.create_collection_path(:app => app)
      path.should == 'apps/1/environments'
    end
  end

  context "deploying" do
    let(:app) { EYCli::Model::App.new(:id => 1, :name => 'fake_app') }
    let(:env) do
      EYCli::Model::Environment.new(
        :id => 1,
        :deployment_configurations => {
          'fake_app' => {:migrate => {:perform => true, :command => 'rake db:migrate'}}
      })
    end
    let(:deploy_uri) { 'http://example.com/apps/1/environments/1/deployments/deploy' }

    it "uses the default deployment options when the provided options are empty" do
      stub_request(:post, "#{deploy_uri}?deployment[migrate]=true&deployment[migrate_command]=rake db:migrate&deployment[ref]=HEAD").
        to_return(:status => 201, :body => to_json(:deployment => {}))

      env.deploy(app)
    end

    it "uses the provided options as deploy parameters" do
      stub_request(:post, "#{deploy_uri}?deployment[migrate]=false&deployment[migrate_command]=fake_migrate&deployment[ref]=master").
        to_return(:status => 201, :body => to_json(:deployment => {}))

      env.deploy(app, {:migrate => false, :migrate_command => 'fake_migrate', :ref => 'master'})
    end

    it "returns the body of the response when there is an error" do
      expected_body = Hashie::Mash.new({:errors => {:provision => 'Amazon is down'}})
      stub_request(:post, "#{deploy_uri}?deployment[migrate]=true&deployment[migrate_command]=rake db:migrate&deployment[ref]=HEAD").
        to_return(:status => 400, :body => to_json(expected_body))

      response = env.deploy(app)
      response.should == expected_body
    end
  end
end
