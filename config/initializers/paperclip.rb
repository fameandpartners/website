require 'paperclip/protocol_relative_url_support'
Paperclip::Attachment.send :include, Paperclip::ProtocolRelativeURLSupport

if Rails.application.config.use_s3
  Paperclip::Attachment.default_options.merge!(
    :storage => :s3,
    :path => "/system/:attachment/:id/:style/:basename.:extension",
    :url => ":s3_alias_url",
    :s3_credentials => {
      :bucket => configatron.aws.s3.bucket,
      :access_key_id => configatron.aws.s3.access_key_id,
      :secret_access_key => configatron.aws.s3.secret_access_key
    },
    s3_host_alias: configatron.aws.host
  )
else
  Paperclip::Attachment.default_options.merge!(
    :storage => :filesystem
  )
end
