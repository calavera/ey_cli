require File.expand_path('../../spec_helper', File.dirname(__FILE__))

class EYCli::Command::WithoutHelp; def help; end end
class EYCli::Command::WithHelp; def help; 'run with_help' end end

describe EYCli::Command::Help do
  before do
    EYCli.command_manager.register_command :without_help
    EYCli.command_manager.register_command :with_help
  end

  it "prints the global help when the command name is not provided" do
    subject.run([])
    $stdout_test.string.should =~ /ey_cli help commands/
  end

  it "says that the help is not available when the command does not exist" do
    subject.run(['fake_command'])
    $stdout_test.string.should =~ /help not available/
  end

  it "says that the help is not available when the command does not have any help message" do
    subject.run(['without_help'])
    $stdout_test.string.should =~ /help not available for command: 'without_help'/
  end

  it "shows the available commands" do
    subject.run(['commands'])
    $stdout_test.string.should =~ /available commands/
  end

  it "shows the help message for the specified command" do
    subject.run(['with_help'])
    $stdout_test.string.should =~ /run with_help/
  end
end
