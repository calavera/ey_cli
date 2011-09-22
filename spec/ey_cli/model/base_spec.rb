require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Model::Base do
  class BaseMock < EYCli::Model::Base
    base_path 'base_mock_path'
  end

  class HierarchicalMock < EYCli::Model::Base
    base_path 'parent/%s/children'
  end

  subject { EYCli::Model::Base }

  it "knows its name" do
    EYCli::Model::Account.class_name.should == 'account'
  end

  it "uses the class name as base path to call the api" do
    EYCli::Model::Account.base_path.should == 'accounts'
  end

  it "allows to override the base path calling the method class" do
    BaseMock.base_path.should == 'base_mock_path'
  end

  it "resolves the resource children path given the base path and the variable arguments" do
    path = BaseMock.resolve_child_path(1)
    path.should == 'base_mock_path/1'

    path = HierarchicalMock.resolve_child_path(1, 1)
    path.should == 'parent/1/children/1'
  end
end
