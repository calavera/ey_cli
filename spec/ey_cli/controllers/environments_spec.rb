require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Controller::Environments do
  let(:app) { EYCli::Model::App.new(:id => 1, :name => 'fake_app') }

  context 'creating a new environment' do
    let(:success_params) do
      {
        :app                         => app,
        'environment[name]'          => "#{app.name}_production",
        'environment[framework_env]' => 'production'
      }
    end

    it "shows an error message if the model cannot create the environment" do
      env_with_errors = EYCli::Model::Environment.new({:errors => {:name => 'bad_name'}})
      EYCli.term.should_receive(:print_errors).with(env_with_errors.errors, 'Environment creation failed:')
      EYCli::Model::Environment.should_receive(:create).and_return(env_with_errors)

      subject.create(app, {})
    end

    it "shows a success message when the model creates the app" do
      env = EYCli::Model::Environment.new({:id => 1, :name => 'fake_app_production', :framework_env => 'production'})
      EYCli::Model::Environment.should_receive(:create).with(success_params).and_return(env)
      EYCli.term.should_receive(:success)

      response = subject.create(app, {})
      response.should == env
    end

    it "allows to specify the framework environment as a parameter" do
      params = success_params.merge({'environment[name]' => 'fake_app_staging', 'environment[framework_env]' => 'staging'})
      env = EYCli::Model::Environment.new({:id => 1, :name => 'fake_app_staging', :framework_env => 'staging'})
      EYCli::Model::Environment.should_receive(:create).with(params).and_return(env)
      EYCli.term.should_receive(:success)

      response = subject.create(app, {:framework_env => 'staging'})
      response.should == env
    end

    it "allows to specify the environment name" do
      params = success_params.merge({'environment[name]' => 'fake_environment_name', 'environment[framework_env]' => 'production'})
      env = EYCli::Model::Environment.new({:id => 1, :name => 'fake_environment_name', :framework_env => 'production'})
      EYCli::Model::Environment.should_receive(:create).with(params).and_return(env)
      EYCli.term.should_receive(:success)

      response = subject.create(app, {:env_name => 'fake_environment_name'})
      response.should == env
    end
  end
end
