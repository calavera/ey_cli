require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe EYCli::OptionsParser do

  it 'accepts the account name as an option' do
    opts = subject.parse ['-a', 'fake_account']
    opts[:account].should == 'fake_account'
  end

  it 'accepts the app name as an option' do
    opts = subject.parse ['-p', 'fake_app']
    opts[:app].should == 'fake_app'
  end

  it 'accepts the environment name as an option' do
    opts = subject.parse ['-e', 'fake_env']
    opts[:environment].should == 'fake_env'
  end
end
