require 'spec_helper'

describe NextLogistics::FTP::Interface do
  let(:ftp_double) { instance_double(Net::FTP) }

  before(:each) do
    allow(Net::FTP).to receive(:open).and_return(ftp_double)
    allow(ftp_double).to receive(:read_timeout=)
    allow(ftp_double).to receive(:open_timeout=)
  end

  describe '.initialize' do
    it 'opens a FTP connection with Next' do
      ENV.update({
                   'NEXT_FTP_HOST'     => 'next-host',
                   'NEXT_FTP_USERNAME' => 'next-username',
                   'NEXT_FTP_PASSWORD' => 'next-password'
                 })

      expect(Net::FTP).to receive(:open).with('next-host', 'next-username', 'next-password')
      expect(ftp_double).to receive(:read_timeout=).with(described_class::FTP_TIMEOUT_SECONDS)
      expect(ftp_double).to receive(:open_timeout=).with(described_class::FTP_TIMEOUT_SECONDS)

      described_class.new
    end
  end

  describe '#upload' do
    before(:each) { allow(SecureRandom).to receive(:uuid).and_return('a401a8ac-0374-42bf-b576-c9d470fb3022') }

    it 'uploads a file with UUID + CSV file extension' do
      interface   = described_class.new
      file_double = Tempfile.new('file-double')

      expect(ftp_double).to receive(:chdir).with(described_class::ORDERS_FOLDER)
      expect(ftp_double).to receive(:putbinaryfile).with(file_double, 'a401a8ac-0374-42bf-b576-c9d470fb3022.csv')

      interface.upload(file: file_double)
    end
  end
end
