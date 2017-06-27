module WeddingAtelier
  class ApplicationController < ::ApplicationController
    include WeddingAtelier::Concerns::FeatureFlaggable

    layout 'wedding_atelier/application'
    before_filter :authenticate_spree_user!
    serialization_scope :view_context
  end
end
