# this file needed to update field type from 'multiselect' => 'text'
# unfortunately, campaign monitor doesn't have api to change custom field settings [ other than name ]
# usage
#   load File.join(Rails.root, 'lib', 'campaign_monitor', 'field_type_updater')
#   FieldTypeUpdater.new.update

class FieldTypeUpdater
  attr_reader :list_id, :api_key

  def initialize
    #@api_key = configatron.campaign_monitor.api_key
    #@list_id = configatron.campaign_monitor.list_id
    @api_key = 'f9d32d1a8b31a53fb4b09a9c064e6562'
    @list_id = '63175b5b43d65a82201cba1df16daae3'
  end

  def update
    field_name = 'Sign up reason'
    holder_field_name = 'signupreasonholder'

    # create custom field A
    create_custom_field(holder_field_name)

    # update field A with signup reason value
    copy_values(from: field_name, to: holder_field_name)

    # remove old custom field
    delete_field(field_name)

    # create new field with same name and different settings
    create_custom_field(field_name)

    # update updated field values from subscribers
    copy_values(from: holder_field_name, to: field_name)

    # remove new 
    delete_field(holder_field_name)
  end

  private

    def list
      @list ||= CreateSend::List.new('63175b5b43d65a82201cba1df16daae3')
    end

    def list
      @list ||= CreateSend::List.new(list_id)
    end

    def create_custom_field(name)
      list.create_custom_field(name, 'Text', [], false)
    end

    def copy_values(options = {})
      source = get_field_id_by_name(options[:from])
      target = get_field_id_by_name(options[:to])

      each_subscriber do |subscriber_data|
        value = subscriber_data.CustomFields.find{|f| f.Key == source}.Value
        custom_fields = [{ "Key" => target, "Value" => value }]

        subscriber = CreateSend::Subscriber.new(list_id, subscriber_data.EmailAddress)
        subscriber.update(
          subscriber_data.EmailAddress,
          subscriber_data.Name,
          custom_fields,
          false, false
        )
      end
    end

    def delete_field(name)
      field_id = get_field_id_by_name(name)
      list.delete_custom_field(field_id)
    end

    def get_field_id_by_name(name)
      field = list.custom_fields.find{|field| field['FieldName'].downcase == name.downcase }
      field['Key']
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
