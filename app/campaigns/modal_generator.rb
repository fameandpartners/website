class ModalGenerator
  module ModalParams
    PROMOCODE = ModalParam.new(
      label:        'promocode',
      param:        'pc',
      required:     true,
      encoded:      true,
      type:         ModalParam::Types::STRING
    )

    TEMPLATE_NAME = ModalParam.new(
      label:        'template name',
      param:        'tn',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING,
      placeholder:  "(e.g. 'signup', 'blank')"
    )

    HEADING = ModalParam.new(
      label:        'heading',
      param:        'h',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING
    )

    MESSAGE = ModalParam.new(
      label:        'message',
      param:        'm',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING
    )

    TIMEOUT = ModalParam.new(
      label:        'timeout',
      param:        't',
      required:     true,
      encoded:      false,
      type:         ModalParam::Types::INTEGER,
      placeholder:  "(delay in seconds before modal appear. Defaults to 3 seconds)",
      default_value: 3
    )

    TIMER = ModalParam.new(
      label:        'timer',
      param:        'ti',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::INTEGER,
      placeholder:  "(sets value for countdown timer in hours)"
    )

    CLASS_NAME = ModalParam.new(
      label:        'class name',
      param:        's',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING,
      placeholder:  "(eg. vex-dialog-bottom vex-dialog-pink vex-text vex-dialog-pink-reverse)"
    )

    FACEBOOK_PIXEL_ID = ModalParam.new(
      label:        'facebook pixel id',
      param:        'fb',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING
    )

    CAMPAIGN_UUID = ModalParam.new(
      label:        'campaign UUID',
      param:        'cu',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING,
      placeholder:  "(e.g. 'auto_apply_promo')"
    )

    TRIGGER_BY_EVENT = ModalParam.new(
      label:        'trigger by event',
      param:        'e',
      required:     false,
      encoded:      true,
      type:         ModalParam::Types::STRING,
      placeholder:  "(e.g. 'add-to-cart')"
    )

    POP = ModalParam.new(
      label:         'pop',
      param:         'pop',
      required:      true,
      encoded:       false,
      type:          ModalParam::Types::BOOLEAN,
      default_value: true,
      placeholder:   "(show popup on page load)"
    )

    ALL = [
      HEADING,
      MESSAGE,
      CAMPAIGN_UUID,
      TRIGGER_BY_EVENT,
      PROMOCODE,
      TEMPLATE_NAME,
      CLASS_NAME,
      TIMEOUT,
      TIMER,
      FACEBOOK_PIXEL_ID,
      POP
    ]
  end

  PARAM_LIST = ModalParams::ALL.map {|modal_param| modal_param.param}
end
