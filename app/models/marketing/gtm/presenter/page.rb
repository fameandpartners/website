module Marketing
  module Gtm
    module Presenter
      class Page < Base
        attr_reader :type, :meta_description, :title, :url

        def initialize(type:, meta_description:, title:, url:)
          @type             = type
          @meta_description = meta_description
          @title            = title
          @url              = url
        end

        def key
          'page'.freeze
        end

        def body
          {
              type:            type,
              title:           title,
              url:             url,
              metaDescription: meta_description
              # adDescription: 'This is going to be the adDescription for remarketing', # Not going into V1
          }
        end
      end
    end
  end
end
