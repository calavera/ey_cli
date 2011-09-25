require File.expand_path('../spec_helper', File.dirname(__FILE__))

module EYCli::Command
  class MockCommand; end
end

describe EYCli::CommandManager do
  before { subject.register_command(:mock_command) }

  it "registers commands" do
    subject.commands.keys.should include(:mock_command)
  end

  it "returns nil if the command class is not registered" do
    subject[:bar].should be_nil
  end

  it "returns an instance of the command class if it's registered" do
    subject[:mock_command].should be_instance_of(EYCli::Command::MockCommand)
  end

  it "returns nil if the command class is not defined" do
    subject.register_command(:bar)
    subject[:bar].should be_nil
  end

  it "only loads the command class once" do
    subject.should_receive(:load_command).
            with(:mock_command).
            once.and_return(EYCli::Command::MockCommand.new)
    subject[:mock_command] || subject[:mock_command]
  end
end
