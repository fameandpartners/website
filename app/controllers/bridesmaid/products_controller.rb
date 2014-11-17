class Bridesmaid::ProductsController < Bridesmaid::BaseController
  before_filter :! # only index, btw

  def index
    require_completed_profile!
    set_page_titles

    @banner   = banner
    @colors   = bridesmaid_user_profile.colors
    @products = resource.read_all
  end

  private

    def resource
      @resource ||= Bridesmaid::Products.new(
        current_site_version,
        bridesmaid_user_profile,
        bridesmaid_party_collection
      )
    end

    def banner
      OpenStruct.new(
        title: 'Bridesmaid Dress Selection',
        text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor'
      )
    end

    def bridesmaid_party_collection
      @bridesmaid_party_collection ||= begin
        Spree::Taxon.where(["permalink = ? or permalink = ?", 'edits/bridesmaid-party', 'bridesmaid-party']).first
      end
    end
end
