# load File.join(Rails.root, 'lib', 'campaign_monitor', 'subscribers_exporter.rb')
# SubscribersExporter.new.write_to('export.txt')
#
class SubscribersExporter
  attr_reader :list_id, :api_key

  def production
    true
  end

  def initialize
    if production
      # real
      @api_key = '3f7e4ac86b143e32a5c7b46b83641143'
      @list_id = 'cc9be877f40c64cf389f6e3ea95daa0a'
    else
      # evgenp
      @api_key = 'f9d32d1a8b31a53fb4b09a9c064e6562'
      @list_id = '63175b5b43d65a82201cba1df16daae3'
    end

    init
  end

  def write_to(file_name = 'export.txt')
    File.open(File.join(Rails.root, file_name), 'w+') do |file|
      each_subscriber do |subscriber|
        email = subscriber.EmailAddress
        reason = subscriber.CustomFields.find{|field| field.Key == '[Signupreason]'}['Value'] rescue nil
        #copy = subscriber.CustomFields.find{|field| field.Key == '[signupreasonholder]'}['Value'] rescue nil
        file.puts("'#{ email }' - '#{ reason }'")
        #if reason.to_s != copy.to_s && reason.present?
        #  file.puts("'#{ email }' - '#{ reason }'/'#{ copy }'")
        #end
      end
    end
  end

  private

    def init
      CreateSend.api_key api_key
    end

    def list
      @list ||= CreateSend::List.new(list_id)
    end

    def each_subscriber(&original_block)
      list.active('', 1, 1_000)
      subscribers_count = list.stats["TotalActiveSubscribers"]
      pages_count = (subscribers_count / 1000.0).ceil
      (1..pages_count).each do |page_num|
        list.active('', page_num, 1_000)['Results'].each do |subscriber|
          original_block.call(subscriber)
        end
      end
    end
end
