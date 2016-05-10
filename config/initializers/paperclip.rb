require 'paperclip/protocol_relative_url_support'
Paperclip::Attachment.send :include, Paperclip::ProtocolRelativeURLSupport

if Rails.application.config.use_s3
  Paperclip::Attachment.default_options.merge!(
    storage: :fog,
    fog_credentials: {
      use_iam_profile: true,
      provider: 'AWS',
      region: configatron.aws.s3.region
    },
    fog_directory: configatron.aws.s3.bucket,
    path: "/system/:attachment/:id/:style/:basename.:extension",
    fog_host: configatron.aws.host
  )
else
  Paperclip::Attachment.default_options.merge!(
    :storage => :filesystem
  )
end
