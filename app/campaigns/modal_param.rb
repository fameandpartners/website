class ModalParam
  module Types
    STRING  = 'string'
    BOOLEAN = 'boolean'
    INTEGER = 'integer'

    ALL     = [STRING, BOOLEAN, INTEGER]
  end

  attr_reader :label, :param, :required, :encoded, :type, :default_value, :placeholder

  def initialize(label:, param:, required: false, encoded: false, type:, default_value: nil, placeholder: nil)
    @label         = label
    @param         = param
    @required      = required
    @encoded       = encoded

    if Types::ALL.include?(type)
      @type          = type
    else
      raise ArgumentError, "invalid type for modal param specified"
    end

    @default_value = default_value
    @placeholder   = placeholder
  end
end
