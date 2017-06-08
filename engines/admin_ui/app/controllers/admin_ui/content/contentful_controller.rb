module AdminUi
  module Content
    class ContentfulController < ::AdminUi::ApplicationController      

      def index
        @contentful_versions = ContentfulVersion.order(id: :desc).page(params[:page])
      end

      def show
      end

      def create
        # TODO: @navsamra
        # 1. Create the object that will be saved to DB as json
        # entries = Contentful.getEntries
        # json = Contentful.cleanAndResolveLinks(entries)
        #
        # 2. Create a DB Record
        # 3. ContentfulVersion.save (below)

        json = {}.to_json
        ContentfulVersion.create({
          change_message: params[:change_message],
          contentful_payload: json
        })

        # 4. Push to Rails cache
        # ContentfulVersion.pushCache(json)
        #
        # 5. Respond with success or failure
        render status: 200, json: {
          message: "New Contentful version saved and cached"
        }.to_json
      end


      private

      helper_method :collection

      def collection
        # TODO: @dagnar, help me figure out how to paginate this
        # Potentially using https://github.com/mislav/will_paginate
        # ContentfulVersion.all
        # page = (params[:page] || 1).to_i
        # per_page = (params[:per_page] || 50).to_i
        # @collection ||= ContentfulVersion.all
      end
    end
  end
end
