require 'savon'

module Bronto
  class Client
    def initialize(api_token:, wsdl_path:)
      @api_token = api_token
      @wsdl_path = wsdl_path
    end

    # @param contacts Array or Hash
    # @option email
    def add_contacts(contacts)
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

    private

    attr_reader :api_token, :wsdl_path

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
  end
end
