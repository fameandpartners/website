module AdminUi
  module Logistics
    class UploadController < ::AdminUi::ApplicationController

      def index
        redirect_to new_logistics_upload_url
      end

      def new
        @bergen_stamp = ReturnInventoryItem.where(vendor: 'bergen').last(:order => "id desc", :limit => 1).created_at
        @next_stamp = ReturnInventoryItem.where(vendor: 'next').last(:order => "id desc", :limit => 1).created_at
        # binding.pry
      end

      def create_bergen
        binding.pry
        if params['upload_bergen'].nil?
          flash.error = "Need a file to upload."
          redirect_to new_logistics_upload_url
        end
        filestream = params['upload'].read
        @count = Importers::InventoryIngestor.ingest_bergen(filestream)
        flash.notice = "#{@count}: Items added for Bergen."
        redirect_to new_logistics_upload_url
      end

      def create_next
        binding.pry
        filestream = params['upload_next'].read
        @count = Importers::InventoryIngestor.ingest_next(filestream)
        flash.notice = "#{@count}: Items added for Bergen."
        redirect_to new_logistics_upload_url
      end

    end
  end
end
