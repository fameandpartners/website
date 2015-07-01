require 'base64'

module Admin::ModalsHelper
  def modal_params_json
    modal_params = ModalGenerator::ModalParams::ALL.map do |modal_param|
      data = {
        label:    modal_param.label,
        param:    modal_param.param,
        required: modal_param.required,
        encoded:  modal_param.encoded,
        type:     modal_param.type
      }

      if modal_param.placeholder
        data[:placeholder] = modal_param.placeholder
      end

      if modal_param.default_value
        data[:defaultValue] = modal_param.default_value
      elsif params[modal_param.param]
        if modal_param.encoded
          data[:defaultValue] = decode(params[modal_param.param])
        else
          data[:defaultValue] = params[modal_param.param]
        end
      end

      data
    end

    modal_params.to_json
  end
end
