# application base
configatron.host        = 'fameandpartners.com'
configatron.noreply     = 'Fame & Partners<noreply@fameandpartners.com>'
configatron.admin       = 'team@fameandpartners.com'
configatron.app_name    = 'Fame And Partners'
configatron.sitemap_url = 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
configatron.blog_host   = 'fameandpartners.tumblr.com'

# assets
configatron.aws.enabled    = false
configatron.aws.bucket     = ""
configatron.aws.access_key = ""
configatron.aws.secret_key = ""
configatron.aws.host       = "images.fameandpartners.com" # bucket: fameandpartners
configatron.asset_host     = "assets.fameandpartners.com"

configatron.typekit_id = 'kur6crm'

configatron.links do |links|
  links.twitter   = 'https://twitter.com/fameandpartners'
  links.facebook  = 'http://www.facebook.com/FameandPartners'
  links.youtube   = 'http://www.youtube.com/user/fameandpartners'
  links.google    = 'https://plus.google.com/b/117433562249244184743/117433562249244184743/about/p/pub'
  links.pinterest = 'http://pinterest.com/fameandpartners/'
  links.instagram = 'http://instagram.com/fameandpartners'
  links.rss       = ''
end

configatron.cache.expire do |expire|
  expire.quickly  = 15.minutes
  expire.normally = 1.hour
  expire.long     = 1.day
end

# Test Environment
configatron.customerio.site_id    = '14c8952c36a16f4c20c6'
configatron.customerio.secret_key = 'f1fd531b4d1ac65ca86c'

configatron.order_production_emails = ['production@fameandpartners.dev']

configatron.email_marketing.delay_time do |delay_time|
  delay_time.abandoned_cart                   = 4.hours
  delay_time.quiz_unfinished                  = 12.hours
  delay_time.style_profile_completed          = 1.week
  delay_time.style_profile_completed_reminder = 1.week
  delay_time.added_to_wishlist                = 12.hours
  delay_time.wishlist_item_added              = 48.hours
  delay_time.wishlist_item_added_reminder     = 2.week
end
configatron.email_marketing.store_information = 1.month

configatron.mandrill.smtp do |mandrill|
  mandrill.username = 'eltons@fameandpartners.com'
  mandrill.password = '189aQIbDBG2pBeKxqoth5A'
end

configatron.mailgun.mailbox do |mailgun|
  mailgun.domain   = 'fameandpartners.com.mailgun.org'
  mailgun.username = 'postmaster@fameandpartners.com.mailgun.org'
  mailgun.password = '0mqgbkbz34n1'
end

configatron.campaign_monitor do |campaign_monitor|
  campaign_monitor.api_key = '3f7e4ac86b143e32a5c7b46b83641143'
  campaign_monitor.list_id = 'dafc8802250a7fb08c840d9c4ffadc9f'
end

configatron.mailchimp do |mailchimp|
  mailchimp.api_key = '0340ea09d6c21efd808cce3d9c9440f6-us7'
  mailchimp.list_id = '48f8d360f7'
end

configatron.redis_host = ::FameAndPartners.yaml_config("redis.local.yml")[Rails.env][:hosts]
configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

configatron.es_url = ::FameAndPartners.yaml_config("elasticsearch.local.yml")[Rails.env][:hosts]

configatron.elasticsearch.indices do |index|
  index.spree_products = :spree_products
  index.color_variants = :color_variants
end

configatron.pin_payments.usd_gateways = %W{pk_NxLgEbIIaWwjKEqUnTd6oA pk_FJWiUA3rQW1uXZIg3LwMKQ}

configatron.site_version_detector = Middleware::SiteVersion::Detectors::Path

case Rails.env.to_sym
when :development
  configatron.host = 'localhost.localdomain'

  configatron.cache.expire do |expire|
    expire.quickly  = 1.second
    expire.normally = 30.seconds
    expire.long     = 60.seconds
  end

  configatron.mandrill.smtp do |mandrill|
    mandrill.username = ''
    mandrill.password = ''
  end

  configatron.mailgun.mailbox do |mailgun|
    mailgun.domain   = ''
    mailgun.username = ''
    mailgun.password = ''
  end

  configatron.campaign_monitor do |campaign_monitor|
    campaign_monitor.api_key = ''
    campaign_monitor.list_id = ''
  end

  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_development
    index.color_variants = :color_variants_development
  end

  configatron.es_url = 'http://localhost:9200'

  configatron.redis_options = { namespace: "fame_and_partners_#{Rails.env}", url: "redis://#{configatron.redis_host}/0" }

when :staging
  configatron.host      = 'stage.fameandpartners.com'

  configatron.mailgun.mailbox do |mailbox|
    mailbox.domain   = '23st2ages.com'
    mailbox.username = 'mailer@23stages.com'
    mailbox.password = '80kmdvXlufsZOW'
  end

when :preproduction
  configatron.host      = 'preprod.fameandpartners.com'

  configatron.aws.s3 do |s3|
    s3.bucket            = 'preprod-fameandpartners'
    s3.region            = 'us-west-2'
    s3.access_key_id     = 'AKIAJ7U3MBOEHSMUAOHQ'
    s3.secret_access_key = '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'
  end
  configatron.aws.host = "s3-us-west-2.amazonaws.com/preprod-fameandpartners"

  configatron.redis_host = ::FameAndPartners.yaml_config("redis.yml")[Rails.env][:hosts]
  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

  configatron.es_url = 'https://21b09bd2aadd9ba50c9d2a9658dc99e7.us-west-1.aws.found.io:9243'

  configatron.asset_host = "assets.fameandpartners.com/preprod"

when :production
  configatron.host      = 'www.fameandpartners.com'

  configatron.order_production_emails = ['fameandpartners@hotmail.com', 'orders@fameandpartners.com.cn']

  configatron.aws.s3 do |s3|
    s3.bucket            = 'fameandpartners'
    s3.region            = 'ap-southeast-2'
    s3.access_key_id     = 'AKIAJ7U3MBOEHSMUAOHQ'
    s3.secret_access_key = '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'
  end

  # Production Environment
  configatron.customerio.site_id    = 'a416731201185e0c6f5f'
  configatron.customerio.secret_key = 'f179030b06baa363ea38'

  configatron.redis_host = ::FameAndPartners.yaml_config("redis.yml")[Rails.env][:hosts]
  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

  # configatron.es_url = 'https://b13gy7hlm3:brc6ozc6oi@production-4224690387.us-east-1.bonsai.io'
  # configatron.es_url = YAML::load(File.open("#{Rails.root}/config/elasticsearch.yml"))[Rails.env][:hosts]
  configatron.es_url = 'https://c019a72e2bcb614a3809da7bf7d583c0.us-east-1.aws.found.io:9243'

  configatron.customerio.site_id = 'a416731201185e0c6f5f'
  configatron.typekit_id = 'day0prb'

  configatron.mailchimp do |mailchimp|
    mailchimp.api_key = '0340ea09d6c21efd808cce3d9c9440f6-us7'
    mailchimp.list_id = '48f8d360f7' #<----Massive TODO here.  Put in actual live mailchimp list when we know it.
  end

when :test
  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_test
    index.color_variants = :color_variants_test
  end

  configatron.redis_options = { namespace: "fame_and_partners_#{Rails.env}", url: "redis://#{configatron.redis_host}/0" }
end
