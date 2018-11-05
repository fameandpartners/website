Paperclip::Attachment.default_options.merge!(
  path:            'system/:attachment/:id/:style/:basename.:extension'
)

if Rails.application.config.use_s3
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
    fog_file: {
      cache_control: 'public, max-age=31536000'
    }
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
