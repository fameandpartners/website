require 'spec_helper'
require 'rspec/shell/expectations'


describe 'deploy hook script:' do
  include Rspec::Shell::Expectations

  let!(:stubbed_env) { create_stubbed_env }
  let(:env_vars) do
    { 'SERVER_ROLE' => 'not-exist', 'FRAMEWORK_ENV' => 'not-exist', 'current_app_path' => Rails.root.to_s, 'this_release_dir' => Rails.root.to_s }
  end

  before(:each) do
    stubbed_env.stub_command('curl')
    stubbed_env.stub_command('zdd_unicorn')
    stubbed_env.stub_command('wheneverize_worker')
    stubbed_env.stub_command('mkdir')
    stubbed_env.stub_command('ln')

    yarn_stub = stubbed_env.stub_command('yarn')
    yarn_stub.with_args('install')
    yarn_stub.with_args('run', 'prod')
  end

  hooks_pattern = File.join(Rails.root.join('config/deploy/hooks'), '**', '*.sh')
  Dir.glob(hooks_pattern).each do |hook_path|
    describe "'#{hook_path}'" do
      it 'should not fail' do
        stdout, stderr, status = stubbed_env.execute(
          "/bin/bash #{hook_path}",
          env_vars
        )

        expect(stderr).to be_empty
        expect(status.exitstatus).to be_zero
      end
    end
  end

end
