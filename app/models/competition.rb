module Competition
  def self.table_name_prefix
    'competition_'
  end

  def self.current
    'gregg-sulkin'
  end

  def self.slug
    'greggsulkin'
  end

  def self.exists?(competition_name)
    %w{gregg-sulkin greggsulkin celebrity_formal_outfit}.include?(competition_name.to_s)
  end

  def self.gregg_style_profile
    profile = UserStyleProfile.new
    profile.glam = 19
    profile.girly = 24
    profile.classic = 18
    profile.edgy = 22
    profile.bohemian = 17
    profile
  end
end
