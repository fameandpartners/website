if Rails.env.production? || Rails.env.staging?
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.fog_directory = ENV['AWS_S3_BUCKET']
    config.aws_iam_roles = true

    # Invalidate a file on a cdn after uploading files
    # config.cdn_distribution_id = "12345"
    # config.invalidate = ['file1.js']

    # Increase upload performance by configuring your region
    config.fog_region = ENV['AWS_S3_REGION'] || 'us-east-1'
    #
    # Don't delete files from the store
    config.existing_remote_files = "keep"
    #
    # Automatically replace files with their equivalent gzip compressed version
    # config.gzip_compression = true
    #
    # Use the Rails generated 'manifest.yml' file to produce the list of files to
    # upload instead of searching the assets directory.
    # config.manifest = true
    #
    # Fail silently.  Useful for environments such as Heroku
    config.fail_silently = true
  end
end
