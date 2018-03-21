module AdminUi
  module Logistics
    class UploadController < ::AdminUi::ApplicationController

      def index
        redirect_to new_logistics_upload_url
      end

      def new
        @bergen_stamp = ReturnInventoryItem.where(vendor: 'bergen').last(:order => "id desc", :limit => 1)&.created_at
        @next_stamp = ReturnInventoryItem.where(vendor: 'next').last(:order => "id desc", :limit => 1)&.created_at
      end

      def create_upload
        if params['bergen_file'].present?
          filestream = params['bergen_file'].read
          @count = Importers::InventoryIngestor.ingest_bergen(filestream)
          # flash[:notice] = "#{@count}: Bergen items."
        end
        if params['next_file'].present?
          filestream = params['next_file'].read
          @count = Importers::InventoryIngestor.ingest_next(filestream)
          # flash.now[:notice] = "#{@count}: Next items."
          # flash[:notice] = ""
        end
        if @count.nil?
          flash[:notice] = "Need a file to upload."
        end
        redirect_to new_logistics_upload_url
      end

    end
  end
end
