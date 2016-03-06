# See gems/mumboe-soap4r-1.5.8.7/lib/soap/mapping/mapping.rb
if Rails.env.development? || Rails.env.test? || Rails.env.preproduction?
  module SOAP
    module Mapping
      def self.warn(msg, *args)
        return if msg.start_with?('cannot find mapped class:')
        Kernel.warn(msg, *args)
      end
    end
  end
end

