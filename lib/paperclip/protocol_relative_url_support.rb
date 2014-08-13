module Paperclip
  module ProtocolRelativeURLSupport
    def self.included(base)
      base.alias_method_chain :url, :protocol_relative
    end
 
    def url_with_protocol_relative(style_name = default_style, options = {})
      u = url_without_protocol_relative(style_name, options)
      if options and options[:protocol_relative]
        u.gsub(/^https?:/, '')
      else
        u
      end
    end
  end
end