if Rails.application.config.use_s3
  aws_host_without_protocol = configatron.aws.host.to_s.gsub('https://', '').gsub('http://', '')

  # Custom configurations for Spree forceful usage of Paperclip's S3 storage mode
  Paperclip::Attachment.default_options.merge!(
    url:           ':s3_alias_url',
    s3_host_alias: aws_host_without_protocol,
    s3_protocol:   'https'
  )

  # Reinteractive: trying to use :fog a storage. Spree 1.3 isn't allowing it
  Paperclip::Attachment.default_options.merge!(
    storage:         :fog,
    fog_credentials: {
      use_iam_profile: true,
      provider:        'AWS',
      region:          configatron.aws.s3.region
    },
    fog_host:        configatron.aws.host,
    fog_directory:   configatron.aws.s3.bucket,
    path:            'system/:attachment/:id/:style/:basename.:extension'
  )

  # Spree::Config[:attachment_url] = :fog_public_url
  # Spree::Config[:attachment_url] = :s3_alias_url
  # Spree::Config[:attachment_url] default is :s3_alias_url
else
  Paperclip::Attachment.default_options.merge!(
    storage: :filesystem
  )
end
