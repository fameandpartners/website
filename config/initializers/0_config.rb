# application base
configatron.host = 'example.com'
configatron.noreply = 'noreply@example.com'
configatron.app_name = 'Fame And Partners'

# assets
configatron.aws.enabled = false
configatron.aws.bucket = ""
configatron.aws.access_key = ""
configatron.aws.secret_key = ""

configatron.links.twitter = ''
configatron.links.facebook = ''
configatron.links.google = ''
configatron.links.pinterest = ''
configatron.links.rss = ''



case Rails.env.to_sym
when :development
  configatron.host = 'localhost:3000'
when :test
end
