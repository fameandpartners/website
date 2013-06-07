class Spree::Admin::BlogController < Spree::Admin::BaseController
  def index
    @posts = []
    pending_state = PostState.find_by_title "Pending"
    [:posts, :celebrity_photos, :fashion_news, :prom_tips, :style_tips, :red_carpet_events].each do |model|
      @posts << { type: model, content: pending_state.send(model) }
    end
  end
end
