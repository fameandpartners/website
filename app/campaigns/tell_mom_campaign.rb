class TellMomCampaign < CampaignManager
  UUID = 'tell_mom'

  def can_activate?
  end

  def is_active?
  end

  def expired?
  end

  # this type of campaign does not have any promotion
  def promotion
    nil
  end

  def activate!
  end

  def deactivate!
  end
end
