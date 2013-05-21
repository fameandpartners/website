# application base
configatron.host = 'example.com'
configatron.noreply = 'noreply@fameandpartners.com'
configatron.admin = 'kate@droidlabs.pro'
configatron.app_name = 'Fame And Partners'

# assets
configatron.aws.enabled = false
configatron.aws.bucket = ""
configatron.aws.access_key = ""
configatron.aws.secret_key = ""

configatron.links.twitter = 'https://twitter.com/fameandpartners'
configatron.links.facebook = 'http://www.facebook.com/FameandPartners'
configatron.links.yputube = 'http://www.youtube.com/user/fameandpartners'
configatron.links.google = 'https://plus.google.com/b/117433562249244184743/117433562249244184743/about/p/pub'
configatron.links.pinterest = ''
configatron.links.rss = ''


case Rails.env.to_sym
when :development
  configatron.host = 'localhost:3000'
when :staging
  configatron.host = 'fame.23stages.com'

  configatron.mailgun.mailbox.domain = '23stages.com'
  configatron.mailgun.mailbox.username = 'mailer@23stages.com'
  configatron.mailgun.mailbox.password = '80kmdvXlufsZOW'
when :test
end
