require 'spec_helper'
require 'rspec/shell/expectations'


describe 'should have valid bash syntax for:' do
  include Rspec::Shell::Expectations

  Dir.glob(File.join(Rails.root.join('config/deploy/hooks'), '**', '*.sh')).each do |hook_path|
    it hook_path do
      stubbed_env = create_stubbed_env

      stubbed_env.stub_command('curl')
      stubbed_env.stub_command('zdd_unicorn')
      stubbed_env.stub_command('wheneverize_worker')
      stubbed_env.stub_command('mkdir')
      stubbed_env.stub_command('ln')

      yarn_stub = stubbed_env.stub_command('yarn')
      yarn_stub.with_args('install')
      yarn_stub.with_args('run', 'prod')

      stdout, stderr, status = stubbed_env.execute(
        "/bin/bash #{hook_path}",
        { 'SERVER_ROLE' => 'not-exist', 'FRAMEWORK_ENV' => 'not-exist', 'current_app_path' => Rails.root.to_s, 'this_release_dir' => Rails.root.to_s }
      )

      expect(stderr).to be_empty
      expect(status.exitstatus).to be_zero
    end
  end

end
