module NextLogistics
  class FTP
    CREDENTIALS = {
      host:     ENV['NEXT_FTP_HOST'],
      password: ENV['NEXT_FTP_PASSWORD'],
      username: ENV['NEXT_FTP_USERNAME'],
    }.freeze
  end
end
