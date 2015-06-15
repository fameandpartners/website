# TellMomCampaign is used for FB traffic to show tell mom popup on whishlist page
# This promotion stores information about itself in cookies
#   @tell_mom_started_at [String]               - promotion code to be applied
# In Modals generator one should only specify campaign_uuid=tell_mom (?cu=dGVsbF9tb20%3D)

class TellMomCampaign < CampaignManager
  UUID         = 'tell_mom'
  ENCODED_UUID = 'dGVsbF9tb20='
  DURATION     = 10.days

  def can_activate?
    return true if storage[:tell_mom_started_at].blank?
    time = Time.at(storage[:tell_mom_started_at].to_i)
    time + DURATION.days < Time.now
  end

  def is_active?
    return false if storage[:tell_mom_started_at].blank?
    time = Time.at(storage[:tell_mom_started_at].to_i)
    time + DURATION.days > Time.now
  end

  def expired?
    return false if storage[:tell_mom_started_at].blank?
    time = Time.at(storage[:tell_mom_started_at].to_i)
    time + DURATION.days < Time.now
  end

  # this campaign does not have any promotion
  def promotion
    nil
  end

  def activate!
    storage[:tell_mom_started_at] = Time.now.to_i
  end

  def deactivate!
    storage.delete(:tell_mom_started_at)
  end
end
