class ContentfulVersion < ActiveRecord::Base
  paginates_per 20
  serialize :contentful_payload

  belongs_to :user, :class_name => Spree::User


  # Set the last entry in table to be live!
  # there must be a row created
  def set_new_version
    #check last row has been created and previewed
    candidate_version = self.last
    if (!candidate_version.is_live)
      candidate_version.is_live = true
      return true
    end
    #can't set a version if not first previewed
    false
  end

end
