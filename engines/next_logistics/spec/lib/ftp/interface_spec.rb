require 'spec_helper'

describe NextLogistics::FTP::Interface do
  subject(:interface) { described_class.new }

  before(:each) do
    ENV.update('NEXT_FTP_HOST' => 'next-host',
               'NEXT_FTP_USERNAME' => 'next-username',
               'NEXT_FTP_PASSWORD' => 'next-password')
  end

  describe '.initialize' do
    it 'initializes an FTP with timeout, Next credentials and in passive mode' do
      expect(interface.credentials).to eq(host:     'next-host',
                                          user:     'next-username',
                                          password: 'next-password')
      expect(interface.ftp.passive).to eq(true)
      expect(interface.ftp.read_timeout).to eq(described_class::FTP_TIMEOUT_SECONDS)
      expect(interface.ftp.open_timeout).to eq(described_class::FTP_TIMEOUT_SECONDS)
    end
  end

  describe '#authenticate' do
    let(:ftp_double) { instance_double(Net::FTP) }

    it 'connects and login with Next FTP server' do
      allow(interface).to receive(:ftp).and_return(ftp_double)
      expect(ftp_double).to receive(:connect).with('next-host')
      expect(ftp_double).to receive(:login).with('next-username', 'next-password')

      interface.authenticate
    end
  end

  describe '#upload' do
    let(:ftp_double) { instance_double(Net::FTP) }

    before(:each) do
      allow(SecureRandom).to receive(:uuid).and_return('a401a8ac-0374-42bf-b576-c9d470fb3022')
      allow(interface).to receive_messages(authenticate: 'ok', ftp: ftp_double)
    end

    it 'uploads a file with UUID + CSV file extension' do
      file_double = Tempfile.new('file-double')

      expect(ftp_double).to receive(:chdir).with(described_class::ORDERS_FOLDER)
      expect(ftp_double).to receive(:putbinaryfile).with(file_double, 'a401a8ac-0374-42bf-b576-c9d470fb3022.csv')

      interface.upload(file: file_double)
    end
  end
end
