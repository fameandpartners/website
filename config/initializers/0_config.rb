# application base
configatron.host = 'example.com'
configatron.noreply = 'Fame & Partners<noreply@fameandpartners.com>'
configatron.admin = 'team@fameandpartners.com'
configatron.app_name = 'Fame And Partners'

# assets
configatron.aws.enabled = false
configatron.aws.bucket = ""
configatron.aws.access_key = ""
configatron.aws.secret_key = ""
# configatron.aws.host = "d1sd72h9dq237j.cloudfront.net"  # bucket: fameandpartners
configatron.aws.host = "daoiay428tmxk.cloudfront.net"   # bucket: products-fameandpartners
# configatron.aws.host = "images.fameandpartners.com"
# configatron.aws.host = "product-images.fameandpartners.com"

configatron.links.twitter = 'https://twitter.com/fameandpartners'
configatron.links.facebook = 'http://www.facebook.com/FameandPartners'
configatron.links.youtube = 'http://www.youtube.com/user/fameandpartners'
configatron.links.google = 'https://plus.google.com/b/117433562249244184743/117433562249244184743/about/p/pub'
configatron.links.pinterest = 'http://pinterest.com/fameandpartners/'
configatron.links.instagram = 'http://instagram.com/fameandpartners'
configatron.links.rss = ''

configatron.cache.expire.quickly = 15.minutes
configatron.cache.expire.normally = 1.hour
configatron.cache.expire.long = 1.day

configatron.email_marketing.delay_time.abandoned_cart = 1.hour
configatron.email_marketing.delay_time.quiz_unfinished = 12.hours
configatron.email_marketing.delay_time.style_profile_completed = 1.week
configatron.email_marketing.delay_time.style_profile_completed_reminder = 1.week
configatron.email_marketing.delay_time.added_to_wishlist = 12.hours
configatron.email_marketing.delay_time.wishlist_item_added = 48.hours
configatron.email_marketing.delay_time.wishlist_item_added_reminder = 2.week
configatron.email_marketing.store_information = 1.month

configatron.redis_options = { :namespace => 'fame_and_partners' }

case Rails.env.to_sym
when :development
  configatron.host = 'localhost.localdomain'
  configatron.blog_host = 'blog.localdomain'
when :staging
  #configatron.host = 'fame.23stages.com'
  #configatron.blog_host = 'blog.fame.23stages.com'
  configatron.host = 'stage.fameandpartners.com'
  configatron.blog_host = 'stage.fameandpartners.com'

  configatron.mailgun.mailbox.domain = '23st2ages.com'
  configatron.mailgun.mailbox.username = 'mailer@23stages.com'
  configatron.mailgun.mailbox.password = '80kmdvXlufsZOW'

  configatron.mandrill.smtp.username = 'eltons@fameandpartners.com'
  configatron.mandrill.smtp.password = '189aQIbDBG2pBeKxqoth5A'
when :preproduction
  configatron.host = 'preprod.fameandpartners.com'
  configatron.blog_host = 'blog.fameandpartners.com'

  configatron.mailgun.mailbox.domain = 'fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.username = 'postmaster@fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.password = '0mqgbkbz34n1'

  configatron.campaign_monitor.api_key = '3f7e4ac86b143e32a5c7b46b83641143'
  configatron.campaign_monitor.list_id = 'cc9be877f40c64cf389f6e3ea95daa0a'

  configatron.mandrill.smtp.username = 'eltons@fameandpartners.com'
  configatron.mandrill.smtp.password = '189aQIbDBG2pBeKxqoth5A'

  configatron.aws.s3.bucket = 'preprod-fameandpartners'
  configatron.aws.s3.access_key_id = 'AKIAJ7U3MBOEHSMUAOHQ'
  configatron.aws.s3.secret_access_key = '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'

  configatron.aws.host = "s3-us-west-2.amazonaws.com/preprod-fameandpartners/"

  redis_host = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env][:hosts]
  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{redis_host}/0" }

  configatron.es_url YAML::load(File.open("#{Rails.root}/config/elasticsearch.yml"))[Rails.env][:hosts]
when :production
  configatron.host = 'www.fameandpartners.com'
  configatron.blog_host = 'blog.fameandpartners.com'

  configatron.mailgun.mailbox.domain = 'fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.username = 'postmaster@fameandpartners.com.mailgun.org'
  configatron.mailgun.mailbox.password = '0mqgbkbz34n1'

  configatron.campaign_monitor.api_key = '3f7e4ac86b143e32a5c7b46b83641143'
  configatron.campaign_monitor.list_id = 'cc9be877f40c64cf389f6e3ea95daa0a'

  configatron.mandrill.smtp.username = 'eltons@fameandpartners.com'
  configatron.mandrill.smtp.password = '189aQIbDBG2pBeKxqoth5A'

  # configatron.aws.s3.bucket = 'fameandpartners'
  configatron.aws.s3.bucket = 'products-fameandpartners'
  configatron.aws.s3.access_key_id = 'AKIAJ7U3MBOEHSMUAOHQ'
  configatron.aws.s3.secret_access_key = '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'

  redis_host = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env][:hosts]
  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{redis_host}/0" }

  configatron.es_url YAML::load(File.open("#{Rails.root}/config/elasticsearch.yml"))[Rails.env][:hosts]
when :test
end
