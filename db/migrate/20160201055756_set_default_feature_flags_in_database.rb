class SetDefaultFeatureFlagsInDatabase < ActiveRecord::Migration

  class SimpleKeyValue < ActiveRecord::Base
    attr_accessible :key, :data
  end

  def up
    default_feature_flags = {
      "feature:checkout_fb_login"         => "100|",
      "feature:content_revolution"        => "100|",
      "feature:fameweddings"              => "100|",
      "feature:height_customisation"      => "100|",
      "feature:marketing_modals"          => "100|",
      "feature:masterpass"                => "100|",
      "feature:moodboard"                 => "100|",
      "feature:redirect_to_com_au_domain" => "100|",
      "feature:google_tag_manager"        => "100|",
      "feature:getitquick_unavailable"    => "100|",
      "feature:test_analytics"            => "0|",
      "feature:__features__"              => "checkout_fb_login,content_revolution,enhanced_moodboards,fameweddings,google_tag_manager,height_customisation,marketing_modals,masterpass,test_analytics,moodboard,redirect_to_com_au_domain,getitquick_unavailable"
    }

    default_feature_flags.each do |key, data|
      say "Feature #{key}"
      SimpleKeyValue.create(key: key, data: data)
    end
  end

  def down
    # No Op
  end
end
