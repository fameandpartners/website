# application base
configatron.host = 'example.com'
configatron.noreply = 'noreply@fameandpartners.com'
configatron.admin = 'team@fameandpartners.com'
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
configatron.links.pinterest = 'http://pinterest.com/fameandpartners/'
configatron.links.rss = ''


case Rails.env.to_sym
when :development
  configatron.host = 'localhost:3000'
when :staging
  configatron.host = 'fame.23stages.com'

  configatron.mailgun.mailbox.domain = '23stages.com'
  configatron.mailgun.mailbox.username = 'mailer@23stages.com'
  configatron.mailgun.mailbox.password = '80kmdvXlufsZOW'
when :production
  configatron.host = 'fameandpartners.com'

  configatron.mailgun.mailbox.domain = 'fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.username = 'postmaster@fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.password = '0mqgbkbz34n1'
when :test
end
