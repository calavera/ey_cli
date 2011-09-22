require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe 'EYCli::SmartyParser' do
  class Parser; extend EYCli::SmartyParser; end

  it "parse the entities in a recursive mode" do
    out = Parser.smarty({'account' => {'id' => 1}})

    out['account'].should be_instance_of(EYCli::Model::Account)
  end

  it "does not override other instances" do
    out = Parser.smarty({'app'=> {'account' => {}}})

    out['app'].should be_instance_of(EYCli::Model::App)
    out['app'].account.should be_instance_of(EYCli::Model::Account)
  end
end
