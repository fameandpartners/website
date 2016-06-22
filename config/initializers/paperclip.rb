if Rails.application.config.use_s3
  Paperclip::Attachment.default_options.merge!(
    storage:        :s3,
    path:           '/system/:attachment/:id/:style/:basename.:extension',
    url:            ':s3_alias_url',
    s3_credentials: {
      bucket:            configatron.aws.s3.bucket,
      access_key_id:     configatron.aws.s3.access_key_id,
      secret_access_key: configatron.aws.s3.secret_access_key
    },
    s3_host_alias:  configatron.aws.host,
    s3_protocol: 'https'
  )

  # Reinteractive: trying to use :fog a storage. Spree 1.3 isn't allowing it
  # Paperclip::Attachment.default_options.merge!(
  #   storage: :fog,
  #   fog_credentials: {
  #     use_iam_profile: true,
  #     provider: 'AWS',
  #     region: configatron.aws.s3.region
  #   },
  #   fog_directory: configatron.aws.s3.bucket,
  #   path: "/system/:attachment/:id/:style/:basename.:extension",
  #   fog_host: configatron.aws.host
  # )
else
  Paperclip::Attachment.default_options.merge!(
    storage: :filesystem
  )
end
