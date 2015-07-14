class CampaignManager
  attr_reader :storage, :campaign_attrs, :current_order, :current_site_version

  class_attribute :is_expirable

  def initialize(storage:, campaign_attrs:, current_order: nil, current_site_version: nil)
    @storage              = storage
    @campaign_attrs       = campaign_attrs
    @current_order        = current_order
    @current_site_version = current_site_version
    clear_attributes
  end

  class << self
    def expirable!
      self.is_expirable = true
    end

    def is_expirable?
      !!self.is_expirable
    end
  end

  def can_activate?
    raise NotImplementedError, "you should implement this methond in derived class"
  end

  def is_active?
    raise NotImplementedError, "you should implement this methond in derived class"
  end

  def activate!
    raise NotImplementedError, "you should implement this methond in derived class"
  end

  def deactivate!
    raise NotImplementedError, "you should implement this methond in derived class"
  end

  private

  def decode(str)
    Base64.decode64(str.to_s)
  end

  def clear_attributes
    # override in derived class if needed
  end
end
