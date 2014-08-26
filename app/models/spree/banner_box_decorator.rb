Spree::BannerBox.class_eval do
  attr_accessible :is_small
  has_attached_file :attachment,
                :url  => "/spree/banners/:id/:style_:basename.:extension",
                :path => ":rails_root/public/spree/banners/:id/:style_:basename.:extension",
                :styles => lambda {|a|{
                  :mini => "80x80#",
                  :small => "358x500#",
                  :big => "1140x500#",
                  :custom => "#{a.instance.attachment_width}x#{a.instance.attachment_height}#"
                }},
                :convert_options => { :all => '-strip -auto-orient' }
                
  def self.big_banner
    self.where('is_small =? and enabled =?',false,true).order('updated_at DESC').first
  end  

  def self.small_banner
    self.where('is_small =? and enabled =?',true, true).order('position ASC')
  end
  
end
