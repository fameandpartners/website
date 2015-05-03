# load File.join(Rails.root, 'lib', 'campaign_monitor', 'subscribers_migrator.rb')
# SubscribersMigrator.new.process
#
#   how to do it:
#     migrator = SubscribersMigrator.new.
#     migrator.load_subscribers(start_from = 0)
#     migrator.export

class CreateSend::List
  def each_subscriber(&original_block)
    page_size = 1_000
    self.active('', 1, 10) # load data
    subscribers_count = self.stats["TotalActiveSubscribers"]
    pages_count = (subscribers_count / page_size.to_f).ceil

    (1..pages_count).each do |page_num|
      puts "started processing page #{ page_num } / #{ pages_count }"
      self.active('', page_num, page_size)['Results'].each_with_index do |subscriber, index|
        subscriber_position = page_size * (page_num - 1) + index
        original_block.call(subscriber, subscriber_position)
      end
    end
  end
end

class SubscribersMigrator
  attr_reader :subscribers

  def load_subscribers(start_from = 0)
    lists[start_from..-1].each_with_index do |list, index|
      puts "processing list ##{ index } [ #{ list.list_id } ]"
      load_subscribers_from_list(list)
    end
  end

  def export
    subscribers = redis.keys("createsend_subscriber_*").map do |key|
      JSON.parse(redis.get(key)) rescue nil
    end.compact
    CreateSend::Subscriber.import(target_list_id, subscribers, false, false, false)
  end

  def clean
    if Rails.env.development?
      redis.flushdb
    else
      redis.del(redis.keys("createsend_subscriber_*"))
    end
  end

  private

    def redis
      @redis ||= Redis.new(configatron.redis_options)
    end

    def load_subscribers_from_list(list)
      list_details = list.details
      list_fields = list.custom_fields
      puts "processing #{ list_details['Title'] }"

      list.each_subscriber do |subscriber, index|
        custom_fields = extract_custom_fields(list_fields, subscriber.CustomFields)

        custom_fields.merge!({
          'EmailAddress' => subscriber.EmailAddress,
          'Name' => subscriber.Name,
          'Joindate' => subscriber.Date
        }.select{|k,v| v.present?})

        append_new_subscriber(list_details['Title'], custom_fields)
      end
    end

    def append_new_subscriber(list_title, fields)
      email = fields['EmailAddress']
      key = "createsend_subscriber_#{ email }"

      raw_subscriber = redis.get(key)
      if raw_subscriber.present?
        subscriber = JSON.parse(raw_subscriber)
        subscriber = subscriber.merge(fields)
        subscriber['lists'] ||= []
        subscriber['lists'] = (subscriber['lists'] + [list_title]).uniq
      else
        subscriber = fields
        subscriber['lists'] = [list_title]
      end
      redis.set(key, subscriber.to_json)
      subscriber
    end

    def extract_custom_fields(list_custom_fields, subscriber_custom_fields)
      return {} if list_custom_fields.blank? || subscriber_custom_fields.blank?

      result = {}
      subscriber_custom_fields.each do |custom_field|
        key = custom_field['Key']
        new_key = custom_fields_mapping[key.downcase]
        if new_key.present? && custom_field['Value'].present?
          result[new_key] = custom_field['Value']
        end
      end
      result
    end

    def custom_fields_mapping
      {
        '[name]'          => 'Name',
        '[signupdate]'    => 'Joindate',
        '[sign up date]'  => 'Joindate',
        '[country]'       => 'country',
        '[campaign]'      => 'campaign',
        '[join_tag]'      => 'tag',
        '[tag]'           => 'tag',
        '[blogname]'      => 'tag',
        '[program]'       => 'tag',
        '[originator]'    => 'source',
        '[referrer]'      => 'source',
        '[ip_address]'    => 'ipaddress',
        '[sourcename]'    => 'source',
        '[joint-tag]'     => 'tag',
        '[adtext]'        => 'note'
      }
    end

    def target_list
      @target_list ||= CreateSend::List.new(target_list_id)
    end

    def lists
      @lists ||= list_ids.map do |list_id|
        CreateSend::List.new(list_id)
      end
    end

    def target_list_id
      'dafc8802250a7fb08c840d9c4ffadc9f'
    end

    def list_ids
      [
        '38d3867f0e6d1a2b6386e101bc92d270',
        '9b1e33c2c839e3732bb8920eab7c4412',
        'df375a820aa6e36ebee5ba9dad12b106',
        '1a056275f8206372785cb45c43c1d21c',
        '6639abf86db87c6c0720f309e25099c8',
        'cddce25f193f40742d6ca576c9706566',
        '33197e55e64ae7b76266702d3840c104',
        'cfc8ccf7145656e1093d54a5cfe6b3e9',
        '0cfa08b76cadaa2f277f1e9d95f93071',
        '1ad34dd2e277f71565aec3d5e407fa3a',
        'cba720e1cf2b4ac94287a963a4983d14',
        '73fae2e6ef9304f19015fc5172be2fcc',
        'd3d88183ce717f2a0f0cabbbfd4beb18',
        'a59708df544a5b9c8a880319c2f2986c',
        'ab3ac320c1a5ca6b958a97c3339ea906',
        '267b3ca17a521cf37d9152ce4cb2db0b',
        '1ef933a98c92ed2340f7e65096eb5810',
        '162a80dd8604ee08dda3382fe74f5374',
        'bfd7a6aabc05335de26282dcbaeec861',
        '1ea39acc776018de1b06c187b1667f70',
        'ca1c9e1afbae584ef924faaeeabe4b44',
        '95817bf7dbc99d292a7eee57fef7b888',
        'dcf3bbc10f4515061687ef889f8729c3',
        'ae9156c5d322655f27048577c4e71840',
        '388996583c1e96dbafe235a91f41c74e',
        '405d865cc6d267da0f166c62ae688996',
        'd6ac405706e76df9f67dca1b3f904bf3',
        'cc9be877f40c64cf389f6e3ea95daa0a',
        '88def56acaceda70281eb8f627f57f49',
        'f042480f5cd0a4c8df61ca806ad21040',
        '25f08a7b3d3e10b5d3482aedc5626833',
        'a2b05a5b20c8e6bcc9b63af97528b4ae',
        '61bd69707c27c61ecf076edf09be148d',
        'bdcd6c85de8ea70a6ec9671e75a25718',
        'e20b1d840b106679789a1216ed4a4098',
        'ed8e5e8b11335cd4b62d9c88027bd0ab',
        'da15ebda4699f3e5950c636450a47d6f',
        'a38f53c257f01e65bced3a616081d5fa'
      ]
    end
end
