# encoding: UTF-8

# See https://api.slack.com/incoming-webhooks
# See https://support.cloud.engineyard.com/entries/21016568-Use-Ruby-Deploy-Hooks

require 'json'
require 'forwardable'

class DeploymentMessage
  extend Forwardable

  def initialize(config)
    @config = config
  end

  # Available Engineyard Config Attributes
  def_delegators :@config, :account_name, :all_releases, :app, :current_name, :current_path, :current_role,
                 :deployed_by, :framework_env, :environment_name, :input_ref, :latest_release, :migrate?, :node,
                 :previous_release , :oldest_release, :release_dir, :release_path, :repo, :repository_cache,
                 :active_revision, :shared_path, :stack

  alias_method :sha, :active_revision

  def text
    "*#{deployed_by}* starting deploying *#{app}* #{branch} (#{commit}) to *#{environment_name}* #{latest_release}"
  end

  def username
    theme[:username]
  end

  # Use any channel or user name
  # "#channel"
  # "@user"
  def channel
    theme[:channel]
  end

  # Use any slack emoji name
  def icon
    ":#{theme[:icon]}:"
  end

  def branch
    "<https://github.com/fameandpartners/website/tree/#{input_ref}|#{input_ref}>"
  end

  def commit
    "<https://github.com/fameandpartners/website/commit/#{sha}|#{short_sha}>"
  end

  def short_sha
    sha.slice(0,7)
  end

  def theme
    {
      'production_new' =>
        {
          username: 'FameBot',
          icon: %w(lipstick dancer star).sample,
          channel: '#development'
        }
    }.fetch(environment_name) do
      {
        username: 'FameBot',
        icon: %w(godmode shipit rocket).sample,
        channel: "#dev-robots"
      }
    end
  end
end

class Slack
  extend Forwardable

  SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"

  def self.post(message)
    new(message).command
  end

  def_delegators :@message, :channel, :username, :icon, :text

  def initialize(message)
    @message = message
  end

  def command
    "curl -X POST --data-urlencode '#{data}' #{SLACK_WEBHOOK_URL}"
  end

  private

  def payload
    {
        channel:    channel,
        username:   username,
        icon_emoji: icon,
        text:       text
    }
  end

  def data
    "payload=#{payload.to_json}"
  end
end

# def test_config
#   require 'ostruct'
#   config = OpenStruct.new
#   config.app = "fame_and_partners"
#   config.deployed_by = "garrow"
#   config.input_ref = "master"
#   config.latest_release = "123456789"
#   config.active_revision = "00b349a693d34a841fe3c4007f09ede37749e8e4"
#   config.environment_name = "preprod"
#   config
# end

on_app_master do
  run Slack.post(DeploymentMessage.new config)
end
