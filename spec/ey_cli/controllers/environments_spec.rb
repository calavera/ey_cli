require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe EYCli::Controller::Environments do
  let(:app) { EYCli::Model::App.new(:id => 1, :name => 'fake_app') }

  context 'creating a new environment' do
    let(:success_params) do
      {
        :app                         => app,
        'environment[name]'          => "#{app.name}_production",
        'environment[framework_env]' => 'production',
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

      response = subject.create(app, {:name => 'fake_environment_name'})
      response.should == env
    end
  end

  context "deploying an environment" do
    it "shows an error if the application doesn't have any environment" do
      EYCli.term.should_receive(:error)
      subject.deploy(app)
    end

    context "when the app has only one environment" do
      before do
        @env = mock
        app[:environments] = [@env]
      end

      it "uses the environment without asking" do
        @env.should_receive(:deploy).and_return(Hashie::Mash.new)
        EYCli.term.should_not_receive(:choose_resource)
        subject.deploy(app)
      end

      it "shows the error list when the deploy fails" do
        expected = Hashie::Mash.new({:errors => {:provision => 'Amazon cannot provision the instance'}})
        @env.should_receive(:deploy).and_return(expected)
        EYCli.term.should_receive(:print_errors).with(expected.errors, "Application deployment failed:")
        subject.deploy(app)
      end

      it "shows the success message if it doesn't return any error" do
        @env.should_receive(:deploy).and_return(Hashie::Mash.new)
        EYCli.term.should_receive(:success)
        subject.deploy(app)
      end
    end

    context "when the app has more than one environment" do
      it "shows the environments' list to let the user choose" do
        env1 = EYCli::Model::Environment.new(:name => 'mock1')
        env2 = mock
        env2.should_receive(:name).and_return('mock2')
        env2.should_receive(:deploy).and_return(Hashie::Mash.new)
        app[:environments] = [env1, env2]
        EYCli.term.should_receive(:choose_resource).and_return('mock2')
        subject.deploy(app)
      end
    end
  end
end
