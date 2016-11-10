require 'net/ftp'
require 'securerandom'

module NextLogistics
  module FTP
    class Interface
      FTP_TIMEOUT_SECONDS = 20

      ORDERS_FOLDER = '/incoming/receipts'.freeze

      # NOTE: Upload must be set to binary! From Next Docs: "please ensure you use BINARY mode for transfers"
      # Upload information from Roger Oliveira:
      # => Folder to upload: `/incoming/receipts`
      # => File name does not have restrictions. Will upload timestamp + receipt.csv pattern

      attr_reader :ftp, :credentials

      def initialize
        @credentials = {
          host:     ENV['NEXT_FTP_HOST'],
          user:     ENV['NEXT_FTP_USERNAME'],
          password: ENV['NEXT_FTP_PASSWORD']
        }

        @ftp              = Net::FTP.new
        @ftp.read_timeout = FTP_TIMEOUT_SECONDS
        @ftp.open_timeout = FTP_TIMEOUT_SECONDS
      end

      def authenticate
        ftp.connect(credentials[:host])
        ftp.login(credentials[:user], credentials[:password])
      end

      def upload(file:)
        authenticate

        remote_filename = [SecureRandom.uuid, '.csv'].join

        ftp.chdir(ORDERS_FOLDER)
        ftp.putbinaryfile(file, remote_filename)
      end
    end
  end
end
