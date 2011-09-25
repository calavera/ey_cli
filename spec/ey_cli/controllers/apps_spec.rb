require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Controller::Apps do
  before { Dir.mkdir('fake_app') }
  let(:account) { EYCli::Model::Account.new(:id => 1) }

  it "shows an error message when the directory is not a git repository" do
    EYCli.term.should_receive(:error).with('Not a git repository: fake_app')
    subject.create(account, 'fake_app')
  end

  context 'trying to figure out the application type' do
    it "uses rails 3 as default" do
      subject.fetch_type('fake_app').should == :rails3
    end

    it 'is a rails 3 app if the directory has the environment and rackup files' do
      Dir.mkdir('fake_app/config')
      ['fake_app/config.ru', 'fake_app/config/environment.rb'].each {|f| File.open(f, 'w')}

      subject.fetch_type('fake_app').should == :rails3
    end

    it 'is a rails 2 app if the directory only includes the environment file' do
      Dir.mkdir('fake_app/config')
      File.open('fake_app/config/environment.rb', 'w')
      subject.fetch_type('fake_app').should == :rails2
    end

    it 'is a rack app if the directory only includes the rackup file' do
      File.open('fake_app/config.ru', 'w')
      subject.fetch_type('fake_app').should == :rack
    end
  end

  context 'under a git repository' do
    before { Dir.mkdir('fake_app/.git') }
    let(:success_params) do
      {
        :account => account,
        'app[name]' => 'fake_app',
        'app[app_type_id]' => 'rails3',
        'app[repository_uri]' => 'git@git.com:foo/bar.git'
      }
    end

    it 'shows an error if the model cannot create the application' do
      app_with_errors = EYCli::Model::App.new({:errors => {:name => 'bad_name'}})
      EYCli.term.should_receive(:print_errors).with(app_with_errors.errors, 'App creation failed:')
      EYCli::Model::App.should_receive(:create).and_return(app_with_errors)

      subject.create(account, 'fake_app')
    end

    it "shows a success message when the model creates the app" do
      app = EYCli::Model::App.new({:id => 1, :name => 'fake_app'})
      EYCli::Model::App.should_receive(:create).with(success_params).and_return(app)
      EYCli.term.should_receive(:success)
      subject.should_receive(:fetch_repository).and_return('git@git.com:foo/bar.git')

      subject.create(account, 'fake_app')
    end
  end
end
