#++
# Copyright (c) 2007-2013, Spree Commerce, Inc. and other contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the Spree Commerce, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived from this
#       software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#--
require 'rails/all'
require 'rails/generators'
require 'state_machine'
require 'paperclip'
require 'kaminari'
require 'awesome_nested_set'
require 'acts_as_list'
require 'active_merchant'
require 'ransack'
require 'jquery-rails'
require 'deface'
require 'cancan'
require 'select2-rails'
require 'spree/money'
require 'rabl'

module Spree

  mattr_accessor :user_class

  def self.user_class
    if @@user_class.is_a?(Class)
      raise "Spree.user_class MUST be a String object, not a Class object."
    elsif @@user_class.is_a?(String)
      @@user_class.constantize
    end
  end

  module Core
  end

  # Used to configure Spree.
  #
  # Example:
  #
  #   Spree.config do |config|
  #     config.site_name = "An awesome Spree site"
  #   end
  #
  # This method is defined within the core gem on purpose.
  # Some people may only wish to use the Core part of Spree.
  def self.config(&block)
    yield(Spree::Config)
  end
end

require 'spree/core/ext/active_record'

require 'spree/core/delegate_belongs_to'

require 'spree/core/responder'
require 'spree/core/ssl_requirement'
require 'spree/core/store_helpers'
require 'spree/core/calculated_adjustments'
require 'spree/core/mail_settings'
require 'spree/core/mail_interceptor'
require 'spree/core/middleware/redirect_legacy_product_url'
require 'spree/core/middleware/seo_assist'
require 'spree/core/permalinks'
require 'spree/core/token_resource'
require 'spree/core/s3_support'

require 'spree/core/version'

require 'spree/core/engine'
require 'generators/spree/dummy/dummy_generator'

ActiveRecord::Base.class_eval do
  include Spree::Core::CalculatedAdjustments
  include CollectiveIdea::Acts::NestedSet
end

if defined?(ActionView)
  require 'awesome_nested_set/helper'
  ActionView::Base.class_eval do
    include CollectiveIdea::Acts::NestedSet::Helper
  end
end

ActiveSupport.on_load(:action_view) do
  include Spree::Core::StoreHelpers
end

# Monkey patch to give us miliseconds precision in timestamps
module ActiveSupport
  class TimeWithZone
    # Coerces time to a string for JSON encoding. The default format is ISO 8601. You can get
    # %Y/%m/%d %H:%M:%S +offset style by setting <tt>ActiveSupport::JSON::Encoding.use_standard_json_time_format</tt>
    # to false.
    #
    # ==== Examples
    #
    #   # With ActiveSupport::JSON::Encoding.use_standard_json_time_format = true
    #   Time.utc(2005,2,1,15,15,10).in_time_zone.to_json
    #   # => "2005-02-01T15:15:10.001Z"
    #
    #   # With ActiveSupport::JSON::Encoding.use_standard_json_time_format = false
    #   Time.utc(2005,2,1,15,15,10).in_time_zone.to_json
    #   # => "2005/02/01 15:15:10 +0000"
    #
    def as_json(options = nil)
      if ActiveSupport::JSON::Encoding.use_standard_json_time_format
        xmlschema(3)
      else
        %(#{time.strftime("%Y/%m/%d %H:%M:%S")} #{formatted_offset(false)})
      end
    end
  end
end
