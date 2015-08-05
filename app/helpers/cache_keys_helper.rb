module CacheKeysHelper
  def price_sensitive_cache_key
    "site=#{current_site_version.code},promo=#{current_promotion.try(:code)}"
  end
end
