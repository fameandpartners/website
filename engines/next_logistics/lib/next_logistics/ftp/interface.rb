require 'net/ftp'
require 'securerandom'

module NextLogistics
  module FTP
    class Interface
      ORDERS_FOLDER = '/incoming/receipts'.freeze

      # NOTE: Upload must be set to binary! From Next Docs: "please ensure you use BINARY mode for transfers"
      # Upload information from Roger Oliveira:
      # => Folder to upload: `/incoming/receipts`
      # => File name does not have restrictions. Will upload timestamp + receipt.csv pattern

      attr_reader :ftp

      def initialize
        credentials = [
          ENV['NEXT_FTP_HOST'],
          ENV['NEXT_FTP_USERNAME'],
          ENV['NEXT_FTP_PASSWORD']
        ]

        @ftp = Net::FTP.open(*credentials)
      end

      def upload(file:)
        remote_filename = [SecureRandom.uuid, '.csv'].join

        ftp.chdir(ORDERS_FOLDER)
        ftp.putbinaryfile(file, remote_filename)
      end
    end
  end
end
