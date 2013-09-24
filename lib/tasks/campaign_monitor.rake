namespace :campaign_monitor do
  namespace :synchronize do
    desc 'Synchronize Campaign Monitor`s users list with system`s users list'
    task :users => :environment do
      Spree::User.all.each do |user|
        custom_fields = {
          :Signupdate => user.created_at.to_date.to_s
        }

        if user.sign_up_reason.present?
          custom_fields[:Signupreason] = sign_up_reason_for_campaign_monitor(user.sign_up_reason)
        end

        CampaignMonitor.delay.synchronize(user.email, user, custom_fields)
      end
    end
  end
end

def sign_up_reason_for_campaign_monitor(reason)
  if reason
    case reason
      when 'custom_dress' then
        'Custom dress'
      when 'style_quiz' then
        'Style quiz'
      when 'workshop' then
        'Workshop'
      when 'competition' then
        'Competition'
    end
  end
end
