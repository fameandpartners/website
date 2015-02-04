module Marketing; end

class Marketing::UserVisit < ActiveRecord::Base
  self.table_name = 'marketing_user_visits'

  attr_accessible :spree_user_id,
    :user_token,
    :utm_campaign,
    :utm_source,
    :utm_medium,
    :utm_term,
    :utm_content,
    :referrer,
    :visits
end
