class Bridesmaid::ProductsController < Bridesmaid::BaseController
  before_filter :require_user_logged_in!

  def index
    require_completed_profile!
    set_page_titles

    @banner             = banner
    @color_name         = bridesmaid_user_profile.colors.map{|color| color[:name]}.join(', ')

    # Display dress variants at the top of the page that match the colours the user selected 
    # when they completed the questionnaire.
    @products           = products_resource.read_all
    @consierge_service  = Spree::Variant.find_by_sku('ap10001cs')

    # In the second section of the page display dresses from the bridesmaid taxon 
    # that are also available in the colours the user selected.
    @similar_products   = similar_products_resource(@products.map(&:id)).read_all
  end

  private

    def products_resource
      @products_resource ||= Bridesmaid::Products.new(
        site_version: current_site_version,
        profile: bridesmaid_user_profile,
        collection: bridesmaid_dresses_collection,
        taxon_ids: search_params.taxon_ids,
        body_shapes: search_params.body_shapes
      )
    end

    def search_params
      @search_params ||= Search::Params.new(params)
    end

    def similar_products_resource(product_ids = [])
      @similar_products_resource ||= Bridesmaid::SimilarProducts.new(
        site_version: current_site_version,
        collection:   bridesmaid_dresses_collection,
        taxon_ids:    search_params.taxon_ids,
        body_shapes:  search_params.body_shapes,
        except:       product_ids
      )
    end

    def banner
      FastOpenStruct.new(
        title: 'Bridesmaid Dress Selection',
        text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor'
      )
    end

    def bridesmaid_dresses_collection
      @bridesmaid_dresses_collection ||= begin
        permalinks = ["edits/bridesmaidother", "edits/bridesmaidother", "edits/bridesmaid14", "bridesmaid14"]
        Spree::Taxon.where(["permalink in (?)", permalinks]).to_a
      end
    end
end
