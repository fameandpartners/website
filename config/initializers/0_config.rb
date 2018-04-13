# application base
configatron.host                    = ENV['APP_HOST']
configatron.noreply                 = 'Fame And Partners<noreply@fameandpartners.com>'
configatron.admin                   = 'team@fameandpartners.com'
configatron.app_name                = 'Fame And Partners'
configatron.sitemap_url             = "#{ENV['RAILS_ASSET_HOST']}/sitemap/sitemap.xml.gz"
configatron.blog_host               = 'fameandpartners.tumblr.com'
configatron.days_delivery_emergency = 0
configatron.secret_token            = ENV['RAILS_SECRET_KEY_BASE']

# assets
configatron.asset_host     = ENV['RAILS_ASSET_HOST'] # Production and Marketing Buckets are on the same CloudFront Distribution

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
  mailgun.domain   = ENV['SMTP_DOMAIN']
  mailgun.username = ENV['SMTP_USERNAME']
  mailgun.password = ENV['SMTP_PASSWORD']
end

configatron.mailchimp do |mailchimp|
  mailchimp.api_key = ENV['MAILCHIMP_API_KEY']
  mailchimp.list_id = ENV['MAILCHIMP_LIST_ID']
end

configatron.es_url = ENV['ES_URL2']

configatron.elasticsearch.indices do |index|
  index.spree_products = :spree_products
  index.color_variants = :color_variants
end

configatron.bergen do |bergen|
  bergen.account_id = ENV['BERGEN_ACCOUNT_ID']
  bergen.username   = ENV['BERGEN_USERNAME']
  bergen.password   = ENV['BERGEN_PASSWORD']
end

configatron.newgistics do |newgistics|
  newgistics.api_key = ENV['NEWGISTICS_API_KEY']
  newgistics.merchant_id = ENV['NEWGISTICS_MERCHANT_ID']
  newgistics.disposition_rule_set = ENV['NEWGISTICS_DISPOSITION_RULE_SET'].to_i
  newgistics.uri = 'https://api.newgistics.com/WebAPI/Shipment/'
end

configatron.contentful do |contentful|
  contentful.preview_api_url = ENV['CONTENTFUL_PREVIEW_API_URL']
  contentful.preview_token = ENV['CONTENTFUL_PREVIEW_TOKEN']
  contentful.access_token = ENV['CONTENTFUL_ACCESS_TOKEN']
  contentful.space_id = ENV['CONTENTFUL_SPACE_ID']
end

configatron.site_version_detector_strategy = :path
configatron.micro_influencer_email_address='qa@fameandpartners.com'

configatron.node_pdp_url = ENV['NODE_CONTENT_URL']

configatron.fame_webclient_url = ENV['FAME_WEBCLIENT_URL']
configatron.fame_webclient_regex = /^(\/static|\/dresses-new|\/dresses\/(custom-dress|dress-.*-[0-9]*))/


configatron.order_bot_client_user = ENV['ORDERBOT_USER']
configatron.order_bot_client_pass = ENV['ORDERBOT_PASS']


case Rails.env.to_sym
when :development
  configatron.site_version_detector_strategy = :subdomain

  configatron.cache.expire do |expire|
    expire.quickly  = 1.second
    expire.normally = 30.seconds
    expire.long     = 60.seconds
  end

  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_development
    index.color_variants = :color_variants_development
  end
when :staging
  configatron.site_version_detector_strategy = :top_level_domain

when :production
  configatron.site_version_detector_strategy = :top_level_domain

  configatron.order_production_emails = ['fameandpartners@hotmail.com', 'orders@fameandpartners.com.cn']
  configatron.micro_influencer_email_address='influencerapplications@fameandpartners.com'
when :test
  configatron.site_version_detector_strategy = :subdomain

  configatron.elasticsearch.indices do |index|
    index.spree_products = :spree_products_test
    index.color_variants = :color_variants_test
  end

  configatron.node_pdp_url = ENV['NODE_CONTENT_URL']
end
