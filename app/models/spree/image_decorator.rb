Spree::Image.class_eval do
  attr_accessible :viewable, :attachment_file_name
  attr_accessor :delay_postprocessing

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


    :webp_xxxlarge => '-define webp:lossless=false -quality 85 -strip',
    :webp_xxlarge => '-define webp:lossless=false -quality 85 -strip',
    :webp_xlarge => '-define webp:lossless=false -quality 85 -strip',
    :webp_large => '-define webp:lossless=false -quality 85 -strip',
    :webp_medium => '-define webp:lossless=false -quality 90 -strip',
    :webp_small => '-define webp:lossless=false -quality 90 -strip',
    :webp_xsmall => '-define webp:lossless=false -quality 90 -strip',
    :webp_xxsmall => '-define webp:lossless=false -quality 90 -strip',
  }

  before_post_process :hook_delay_postprocessing
  after_save do
    if delay_postprocessing
      ReprocessImageWorker.perform_async(id)
    end
  end

  def hook_delay_postprocessing
    if delay_postprocessing
      false
    else
      true
    end
  end
end
