class Spree::Admin::BlogController < Spree::Admin::BaseController
  def index
    @posts = []
    pending_state = PostState.find_by_title "Pending"
    [:celebrity_photos, :red_carpet_events].each do |model|
      @posts << { type: model, content: pending_state.send(model) }
    end
    [:posts, :fashion_news, :prom_tips, :style_tips].each do |model|
      posts = Category.where(title: model.to_s.titleize)
      @posts << { type: model, content: posts }
    end
  end
end
