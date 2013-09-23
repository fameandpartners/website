module Spree
  module Admin
    class CustomisationTypesController < ResourceController
      before_filter :setup_new_customisation_value, :only => [:edit]

      def model_class
        CustomisationType
      end

      def update_values_positions
        params[:positions].each do |id, index|
          CustomisationValue.where(:id => id).update_all(:position => index)
        end

        respond_to do |format|
          format.html { redirect_to admin_product_variants_url(params[:product_id]) }
          format.js  { render :text => 'Ok' }
        end
      end

      protected

        def location_after_save
          if @customisation_type.created_at == @customisation_type.updated_at
            edit_admin_customisation_type_url(@customisation_type)
          else
            admin_customisation_types_url
          end
        end


      private
        def load_product
          @product = Product.find_by_param!(params[:product_id])
        end

        def setup_new_customisation_value
          @customisation_type.customisation_values.build if @customisation_type.customisation_values.empty?
        end

        def set_available_customisation_types
          @available_customisation_types = if @product.customisation_type_ids.any?
            CustomisationType.where('id NOT IN (?)', @product.customisation_type_ids)
          else
            CustomisationType.all
          end
        end
    end
  end
end
