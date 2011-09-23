require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Model::Base do
  class BaseMock < EYCli::Model::Base
    base_path 'base_mocks'
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
    BaseMock.base_path.should == 'base_mocks'
  end

  it "resolves the resource children path given the base path and the variable arguments" do
    path = BaseMock.resolve_child_path([1])
    path.should == 'base_mocks/1'

    path = HierarchicalMock.resolve_child_path([1, 1])
    path.should == 'parent/1/children/1'
  end

  context '.all' do
    it "returns the collection of elements" do
      body = to_json({:base_mocks => [{:id => 1, :name => 'foo'}]})
      stub_request(:get, 'http://example.com/base_mocks').
        to_return(:body => body, :status => 200)

      mocks = BaseMock.all
      mocks.should have(1).mocks
    end

    it 'returns an empty array when the collection is empty' do
      body = to_json({:base_mocks => []})
      stub_request(:get, 'http://example.com/base_mocks').
        to_return(:body => body, :status => 200)

      BaseMock.all.should be_empty
    end
  end

  context ".find" do
    it "accepts several identifires to fill the hierarchy" do
      expected = HierarchicalMock.new({:id => 1, :parent => BaseMock.new({:id => 2})})
      stub_request(:get, 'http://example.com/parent/2/children/1').
        to_return(:body => to_json(:hierarchicalmock => expected))

      mock = HierarchicalMock.find(2, 1)
      mock.should == expected
    end

    it "returns the element if exists" do
      expected = BaseMock.new({:id => 1, :name => 'foo'})
      body = to_json({:basemock => expected.to_hash})
      stub_request(:get, 'http://example.com/base_mocks/1').
        to_return(:body => body, :status => 200)

      mock = BaseMock.find 1
      mock.should == expected
    end

    it "raises an error when the element is not found" do
      stub_request(:get, 'http://example.com/base_mocks/1').
        to_return(:status => 404)

      lambda { BaseMock.find 1 }.should raise_error(Faraday::Error::ResourceNotFound)
    end
  end

  context '.find_by_name' do
    before do
      @expected = BaseMock.new({:id => 1, :name => 'foo'})
      body = to_json({:base_mocks => [@expected.to_hash]})
      stub_request(:get, 'http://example.com/base_mocks').
        to_return(:body => body, :status => 200)
    end

    it "returns the elemnet if it finds it by name" do
      mock = BaseMock.find_by_name 'foo'
      mock.should == @expected
    end

    it "raises an error when the element is not found" do
      lambda { BaseMock.find_by_name('bar') }.should raise_error(Faraday::Error::ResourceNotFound)
    end
  end
end
