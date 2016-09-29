require 'json'

module Afterpay::SDK::Core
  class BaseDataType
    AVAILABLE_OPTIONS = [:default, :required].freeze

    def initialize(**initialize_attrs)
      self.class.ensure_options_are_valid!(initialize_attrs)
      update_attributes(initialize_attrs)
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      hash = {}
      self.class.attributes_declarations.each do |key, options|
        name = options.fetch(:alias, key)
        value = self.send(key)

        if value.kind_of?(self.class.superclass)
          value = value.to_hash
        end

        hash[name] = value
      end
      hash
    end

    protected

    def update_attributes(initialize_attrs)
      self.class.attributes_declarations.each do |name, options|
        value = initialize_attrs.fetch(name, options[:default])
        self.class.send(:attr_accessor, name)
        if options.has_key?(:alias)
          self.class.send(:alias_method, options[:alias], name)
        end

        instance_variable_set("@#{name}", value)
      end
    end

    def self.add_attribute(name, **options)
      unknown_keys = options.keys - AVAILABLE_OPTIONS
      if unknown_keys.any?
        raise ArgumentError, \
          "options [ #{unknown_keys.join(', ')} ] are unknown"
      end

      declarations = (attributes_declarations).dup

      new_declaration = {
        required: options.fetch(:required, false),
      }

      if options.has_key?(:default)
        new_declaration[:default] = options[:default]
      end

      if options.has_key?(:alias)
        new_declaration[:alias] = options[:alias]
      end

      declarations[name] = new_declaration.freeze
      @attributes_declarations = declarations.freeze
    end

    def self.attributes_declarations
      @attributes_declarations ||= {}
    end

    def self.ensure_options_are_valid!(options)
      declarations = attributes_declarations
      provided_attributes = options.keys
      known_attributes, unknown_attributes = \
        provided_attributes.partition(&declarations.method(:has_key?))

      required_attributes = declarations.select do |_, declaration|
        declaration.fetch(:required, false)
      end.keys

      missing_attributes = (required_attributes - known_attributes)

      errors = []
      if unknown_attributes.any?
        errors << \
          "keys [ #{unknown_attributes.join(', ')} ] are unknown"
      end

      if missing_attributes.any?
        errors << \
          "keys [ #{missing_attributes.join(', ')} ] are required but missing"
      end

      if errors.any?
        raise ArgumentError, errors.join("; "), caller.join("\n")
      end
    end

  end
end
