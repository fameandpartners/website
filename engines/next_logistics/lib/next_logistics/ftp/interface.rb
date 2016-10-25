module NextLogistics
  module FTP
    class Interface
      CREDENTIALS = {
        host:     ENV['NEXT_FTP_HOST'],
        password: ENV['NEXT_FTP_PASSWORD'],
        username: ENV['NEXT_FTP_USERNAME'],
      }.freeze

      # NOTE: Upload must be set to binary! From Next Docs: "please ensure you use BINARY mode for transfers"

      # TODO: .call or instance method interface? Think!
      # class Upload
      #   def self.call(file:)
      #     # TODO: uploads the CSV file
      #   end
      # end
    end
  end
end
