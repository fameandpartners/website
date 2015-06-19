class CampaignManager
  attr_reader :storage, :campaign_attrs, :current_order, :current_site_version

  def initialize(storage:, campaign_attrs:, current_order:, current_site_version:)
    @storage              = storage
    @campaign_attrs       = campaign_attrs
    @current_order        = current_order
    @current_site_version = current_site_version
    clear_attributes
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

  def clear_attributes
    # override in derived class if needed
  end
end
