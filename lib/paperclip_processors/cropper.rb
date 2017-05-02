module Paperclip
  class Cropper < Thumbnail
    def transformation_command
      crop_command
    end
    
    def crop_command
      "-gravity Center -crop '#{@target_geometry}+0+0' -quality 100 -strip"
    end
  end
end
