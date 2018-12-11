Spree::Image.class_eval do
  attr_accessible :viewable, :attachment_file_name

  self.attachment_definitions[:attachment].merge!(Paperclip::Attachment.default_options)

  self.attachment_definitions[:attachment][:path] = 'spree/products/:id/:style/:basename.:extension'

  self.attachment_definitions[:attachment][:styles] = {
    xxxlarge: '4048x4048>', 
    xxlarge: '2816x2816>', 
    xlarge: '2024x2024>',
    large: '1408x1408>', 
    medium: '1056x1056>', 
    small: '704x704>',
    xsmall: '528x528>',
    xxsmall: '352x352>',

    product: '704x704>',

    webp_xxxlarge: ['4048x4048>', :webp],
    webp_xxlarge: ['2816x2816>', :webp], 
    webp_xlarge: ['2024x2024>', :webp],
    webp_large: ['1408x1408>', :webp],
    webp_medium: ['1056x1056>', :webp], 
    webp_small: ['704x704>', :webp],
    webp_xsmall: ['528x528>', :webp],
    webp_xxsmall: ['352x352>', :webp],
  }

  self.attachment_definitions[:attachment][:convert_options] = {
    :xxxlarge => '-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB',
    :xxlarge => '-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB',
    :xlarge => '-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB',
    :large => '-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB',
    :medium => '-sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB',
    :small => '-sampling-factor 4:2:0 -strip -quality 95 -interlace JPEG -colorspace sRGB',
    :xsmall => '-sampling-factor 4:2:0 -strip -quality 95 -interlace JPEG -colorspace sRGB',
    :xxsmall => '-sampling-factor 4:2:0 -strip -quality 95 -interlace JPEG -colorspace sRGB',

    :product => '-sampling-factor 4:2:0 -strip -quality 95 -interlace JPEG -colorspace sRGB',


    :webp_xxxlarge => '-define webp:lossless=true -strip',
    :webp_xxlarge => '-define webp:lossless=true -strip',
    :webp_xlarge => '-define webp:lossless=true -strip',
    :webp_large => '-define webp:lossless=true -strip',
    :webp_medium => '-define webp:lossless=true -strip',
    :webp_small => '-define webp:lossless=true -strip',
    :webp_xsmall => '-define webp:lossless=true -strip',
    :webp_xxsmall => '-define webp:lossless=true -strip',
  }
end
