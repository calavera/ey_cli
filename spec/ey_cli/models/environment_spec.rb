require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Model::Environment do
  context "creating the resource path" do
    let(:clazz) { EYCli::Model::Environment }
    it "raises an error when the app is not into the parameters hash" do
      lambda { clazz.create_path({}) }.should raise_error
    end

    it "creates the resource path using the application id" do
      app = EYCli::Model::App.new(:id => 1)
      path = clazz.create_path(:app => app)
      path.should == 'apps/1/environments'
    end
  end
end
