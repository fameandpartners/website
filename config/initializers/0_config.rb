# application base
configatron.host                    = 'fameandpartners.com'
configatron.noreply                 = 'Fame & Partners<noreply@fameandpartners.com>'
configatron.admin                   = 'team@fameandpartners.com'
configatron.app_name                = 'Fame And Partners'
configatron.sitemap_url             = 'http://images.fameandpartners.com/sitemap/sitemap.xml.gz'
configatron.blog_host               = 'fameandpartners.tumblr.com'
configatron.days_delivery_emergency = 0
configatron.secret_token            = ENV['SECRET_TOKEN']

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

configatron.customerio.site_id    = ENV['CUSTOMERIO_SITE_ID']
configatron.customerio.secret_key = ENV['CUSTOMERIO_SECRET_KEY']

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

configatron.mailgun.mailbox do |mailgun|
  mailgun.domain   = ENV['MAILGUN_DOMAIN']
  mailgun.username = ENV['MAILGUN_USERNAME']
  mailgun.password = ENV['MAILGUN_PASSWORD']
end

configatron.mailchimp do |mailchimp|
  mailchimp.api_key = ENV['MAILCHIMP_API_KEY']
  mailchimp.list_id = ENV['MAILCHIMP_LIST_ID']
end

configatron.redis_host = ENV['REDIS_HOST']
configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

configatron.es_url = ENV['ES_URL']

configatron.elasticsearch.indices do |index|
  index.spree_products = :spree_products
  index.color_variants = :color_variants
end

configatron.bergen do |bergen|
  bergen.account_id = ENV['BERGEN_ACCOUNT_ID']
  bergen.username   = ENV['BERGEN_USERNAME']
  bergen.password   = ENV['BERGEN_PASSWORD']
end

configatron.pin_payments.usd_gateways = %W{pk_NxLgEbIIaWwjKEqUnTd6oA pk_FJWiUA3rQW1uXZIg3LwMKQ}

configatron.site_version_detector_strategy = :path

configatron.aws.s3 do |s3|
  s3.bucket            = ENV['S3_BUCKET']
  s3.region            = ENV['S3_REGION']
  s3.access_key_id     = ENV['S3_ACCESS_KEY_ID']
  s3.secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
end

case Rails.env.to_sym
when :development
  configatron.site_version_detector_strategy = :subdomain

  configatron.host = 'localhost.localdomain'

  configatron.cache.expire do |expire|
    expire.quickly  = 1.second
    expire.normally = 30.seconds
    expire.long     = 60.seconds
  end

  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_development
    index.color_variants = :color_variants_development
  end

  configatron.redis_options = { namespace: "fame_and_partners_#{Rails.env}", url: "redis://#{configatron.redis_host}/0" }

when :staging
  configatron.host      = 'stage.fameandpartners.com'

when :preproduction
  configatron.host      = 'preprod.fameandpartners.com'

  configatron.aws.host = "s3-us-west-2.amazonaws.com/preprod-fameandpartners"

  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

  configatron.asset_host = "assets.fameandpartners.com/preprod"

when :production
  configatron.site_version_detector_strategy = :top_level_domain
  configatron.host      = 'www.fameandpartners.com'

  configatron.order_production_emails = ['fameandpartners@hotmail.com', 'orders@fameandpartners.com.cn']

  configatron.redis_options = { namespace: 'fame_and_partners', url: "redis://#{configatron.redis_host}/0" }

  configatron.typekit_id = 'day0prb'

when :test
  configatron.site_version_detector_strategy = :subdomain

  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_test
    index.color_variants = :color_variants_test
  end

  configatron.redis_options = { namespace: "fame_and_partners_#{Rails.env}", url: "redis://#{configatron.redis_host}/0" }
end
