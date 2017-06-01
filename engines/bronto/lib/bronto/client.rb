require 'savon'

module Bronto
  class Client
    # @param contacts Array or Hash
    # @option email
    def add_contacts(contacts)
      contacts = Array.wrap(contacts).map do |contact|
        contact[:fields] = prepare_fields(contact[:fields])

        contact
      end

      request(:add_contacts, contacts: Array.wrap(contacts))
    end

    # @param lists Array or Hash
    # @option name
    # @option label
    def add_lists(lists)
      list_options = {
        lists: Array.wrap(lists)
      }

      request(:add_lists, list_options)
    end

    def add_to_list(list_name:, emails:)
      conditions = Array.wrap(emails).map do |email|
        { email: email }
      end
      body = { list: { name: list_name }, contacts: conditions }

      request(:add_to_list, body)
    end

    def contacts_by_email(emails:)
      conditions = Array.wrap(emails).map do |email|
        {
          operator: 'EqualTo',
          value: email
        }
      end

      contact = request(:read_contacts, filter: { type: 'OR', email: conditions })

      contact.hash[:envelope][:body][:read_contacts_response][:return]
    end

    def fields(names:)
      conditions = Array.wrap(names).map do |name|
        {
          operator: 'EqualTo',
          value: name
        }
      end

      filter = { type: 'OR', name: conditions }
      result = request(:read_fields, filter: filter)[:read_fields_response][:return] || []

      fields = Array.wrap(result).map { |field| [field[:name], field[:id]] }

      Hash[*fields.flatten]
    end

    def prepare_fields(fields_hash)
      fields_hash = fields_hash.delete_if{ |k, v| v.blank? }
      field_ids = fields(names: fields_hash.keys)

      fields_hash.each_pair.map do |key, value|
        {
          field_id: field_ids[key.to_s],
          content: value
        }
      end
    end

    private

    def contacts_by_email(emails:)
      conditions = Array.wrap(emails).map do |email|
        {
          operator: 'EqualTo',
          value: email
        }
      end

      contact = request(:read_contacts, filter: { type: 'OR', email: conditions })

      contact.hash[:envelope][:body][:read_contacts_response][:return]
    end

    def client
      @client ||= Savon.client(wsdl_path)
    end

    def login
      client.request(:login) { soap.body = { api_token: api_token } }
    end

    def request(action, body = {})
      client.request(action) do
        soap.header = soap_header
        soap.body = body

        yield(soap) if block_given?
      end
    end

    def session_id
      @session_id ||= login.body[:login_response][:return]
    end

    def logout
      request(:logout)
      @session_id = nil
    end

    def soap_header
      { "tns:sessionHeader" => { session_id: session_id } }
    end

    def api_token
      Bronto.api_token
    end

    def wsdl_path
      Bronto.wsdl_path
    end
  end
end
