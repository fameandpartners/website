if Rails.application.config.use_s3
  aws_host_without_protocol = ENV['RAILS_ASSET_HOST'].to_s.gsub('https://', '').gsub('http://', '')

  # Custom configurations for Spree forceful usage of Paperclip's S3 storage mode
  Paperclip::Attachment.default_options.merge!(
    url:            ':s3_alias_url',
    s3_credentials: {
      bucket: ENV['AWS_S3_BUCKET'],
    },
    s3_host_alias:  aws_host_without_protocol,
    s3_permissions: :public_read,
    s3_protocol:    'https'
  )

  # Reinteractive: trying to use :fog a storage. Spree 1.3 isn't allowing it
  Paperclip::Attachment.default_options.merge!(
    storage:         :fog,
    fog_credentials: {
      use_iam_profile: true,
      provider:        'AWS',
      region:          ENV['AWS_S3_REGION'],
    },
    fog_host:        ENV['RAILS_ASSET_HOST'],
    fog_directory:   ENV['AWS_S3_BUCKET'],
    fog_public:      true,
    path:            'system/:attachment/:id/:style/:basename.:extension'
  )

  if Rails.env.development? && ENV.values_at('AWS_S3_ACCESS_KEY_ID', 'AWS_S3_SECRET_ACCESS_KEY').all?
    Paperclip::Attachment.default_options.merge!(
      fog_credentials: {
        aws_access_key_id:     ENV['AWS_S3_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'],
        provider:              'AWS',
        region:                ENV['AWS_S3_REGION']
      }
    )
  end
else
  Paperclip::Attachment.default_options.merge!(
    storage: :filesystem
  )
end

Paperclip.interpolates('product_id') do |attachment, style| attachment.instance.product.id end 
