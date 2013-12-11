if Rails.env.production?
  Paperclip::Attachment.default_options.merge!(
    :storage => :s3,
    :path => "/system/:class/:attachment/:id_partition/:style/:filename",
    :url => ":s3_domain_url",
    :s3_credentials => {
      :bucket => configatron.aws.s3.bucket,
      :access_key_id => configatron.aws.s3.access_key_id,
      :secret_access_key => configatron.aws.s3.secret_access_key
    }
  )
else
  Paperclip::Attachment.default_options.merge!(
    :storage => :filesystem
  )
end
