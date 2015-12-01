# this file needed to update field type from 'multiselect' => 'text'
# unfortunately, campaign monitor doesn't have api to change custom field settings [ other than name ]
# usage
#   load File.join(Rails.root, 'lib', 'campaign_monitor', 'field_type_updater.rb')
#   FieldTypeUpdater.new.update
#{
#  "FieldName"=>"Sign up reason",
#   "Key"=>"[Signupreason]",
#   "DataType"=>"MultiSelectOne",
#   "FieldOptions"=> ["Custom dress", "Style quiz", "Workshop", "Competition", "Dolly campaign", "Customise dress", "Campaign Style Call", "Newsletter Modal"],
# "VisibleInPreferenceCenter"=>false
#},

class FieldTypeUpdater
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

    def init
      CreateSend.api_key api_key
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

      start_time = Time.now.to_f

      each_subscriber do |subscriber_data, index|
        puts "#{ (Time.now.to_f - start_time).to_s }: processing #{ index } record" if index % 100 == 0

        value = subscriber_data.CustomFields.find{|f| f.Key == source}.Value rescue ''
        current_value = subscriber_data.CustomFields.find{|f| f.Key == target}.Value rescue ''

        next if (value.blank? || current_value == value)

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
        list.active('', page_num, 1_000)['Results'].each_with_index do |subscriber, index|
          subscriber_position = 1000 * (page_num - 1) + index
          original_block.call(subscriber, subscriber_position)
        end
      end
    end
end
