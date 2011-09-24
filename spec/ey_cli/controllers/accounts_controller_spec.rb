require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Controller::Accounts do
  it "returns the first account if we don't provide a name and the user has only one account" do
    expected = EYCli::Model::Account.new({:id => 1, :name => 'foo'})
    stub_request(:get, 'http://example.com/accounts').
      to_return(:status => 200, :body => to_json({'accounts' => [expected]}))

    account = subject.fetch_account
    account.should == expected
  end

  it "returns nil if we don't find the account by the name provided" do
    expected = EYCli::Model::Account.new({:id => 1, :name => 'foo'})
    stub_request(:get, 'http://example.com/accounts').
      to_return(:status => 200, :body => to_json({'accounts' => [expected]}))

    subject.fetch_account('bar').should be_nil
  end

  it "returns nil if the user hasn't created an account yet" do
    stub_request(:get, 'http://example.com/accounts').
      to_return(:status => 200, :body => to_json({'accounts' => []}))

    subject.fetch_account.should be_nil
  end

  it "returns the account selected by the user" do
    account1 = EYCli::Model::Account.new({:id => 1, :name => 'foo'})
    account2 = EYCli::Model::Account.new({:id => 2, :name => 'bar'})
    account3 = EYCli::Model::Account.new({:id => 3, :name => 'baz'})
    stub_request(:get, 'http://example.com/accounts').
      to_return(:status => 200, :body => to_json({'accounts' => [account1, account2, account3]}))

    EYCli.term.terminal.should_receive(:choose).and_return('bar')

    account = subject.fetch_account
    account.should == account2
  end
end
