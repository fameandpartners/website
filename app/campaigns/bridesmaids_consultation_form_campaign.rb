# A slider modal pops up to this traffic that captures customers email addresses.
# Once email address is provided, an email is triggered to this recipient including
# a link to a consultation form. If the customer clicks on this link, he will
# be redirected to the homepage where the wedding consultation form is hosted.
# This form will be similar to the styling session form but capture different
# information that I will define in detail. Once the form is filled out and
# submitted, it triggers an email to Desk using subject line 'wedding consultation'
# In Modals generator one should additionally specify campaign_uuid=bridesmaids_consultation_form
# ClASS_NAME=vex-dialog-bottom vex-dialog-pink vex-text vex-dialog-pink-reverse

class BridesmaidsConsultationFormCampaign < CampaignManager
  expirable!
  UUID         = 'bridesmaids_consultation_form'
  DURATION     = 10.days

  def can_activate?
    return true if storage[:bcf_started_at].blank? && Devise.email_regexp =~ campaign_attrs[:email]
    time = Time.at(storage[:bcf_started_at].to_i)
    time + DURATION.days < Time.now
  end

  def is_active?
    return false if storage[:bcf_started_at].blank?
    time = Time.at(storage[:bcf_started_at].to_i)
    time + DURATION.days > Time.now
  end

  def expired?
    return false if storage[:bcf_started_at].blank?
    time = Time.at(storage[:bcf_started_at].to_i)
    time + DURATION.days < Time.now
  end

  # this campaign does not have any promotion
  def promotion
    nil
  end

  def activate!
    storage[:bcf_started_at] = Time.now.to_i
    MarketingMailer.bridesmaids_consultation_form(campaign_attrs[:email]).deliver
  end

  def deactivate!
    storage.delete(:bcf_started_at)
  end
end
