Spree::BannerBox.class_eval do
  attr_accessible :is_small, :css_class, :title
  has_attached_file :attachment,
                #~ :url  => "/spree/banners/:id/:style_:basename.:extension",
                #~ :path => ":rails_root/public/spree/banners/:id/:style_:basename.:extension",
                :styles => lambda {|a|{
                  :mini => "80x80#",
                  :small => "358x500#",
                  :big => "1140x500#",
                  :custom => "#{a.instance.attachment_width}x#{a.instance.attachment_height}#"
                }},
                :convert_options => { :all => '-strip -auto-orient' }

  scope :big_banner      , -> { where('is_small = ? and enabled = ?', false, true).order('position ASC') }
  scope :small_banner    , -> { where('is_small = ? and enabled = ?', true, true).order('position ASC') }
  scope :for_site_version, -> (site_version) { where("css_class IS NULL OR css_class = '' OR css_class = ?", site_version.code) }
end
