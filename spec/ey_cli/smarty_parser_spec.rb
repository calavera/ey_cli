require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe 'EYCli::SmartyParser' do
  class Parser; extend EYCli::SmartyParser; end

  it "parses the entities in a recursively" do
    out = Parser.smarty({'account' => {'id' => 1}})

    out['account'].should be_instance_of(EYCli::Model::Account)
  end

  it "does not override other instances" do
    out = Parser.smarty({'app'=> {'account' => {}, 'environments' => [{}]}})

    out['app'].should be_instance_of(EYCli::Model::App)
    out['app'].account.should be_instance_of(EYCli::Model::Account)
    out['app'].environments.first.should be_instance_of(EYCli::Model::Environment)
  end
end
