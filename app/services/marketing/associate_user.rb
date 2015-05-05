module Marketing; end

class Marketing::UserVisits
  # user can already have visits, in previous session
  def self.associate_with_user_by_token(options = {})
    user  = options[:user]
    token = options[:token]

    return false if (user.blank? || token.blank?)

    scope = Marketing::UserVisit.where(user_token: token).where(spree_user_id: nil)
    return false if !scope.exists?

    user_visits = Marketing::UserVisit.where(spree_user_id: user.id).to_a

    scope.each do |guest_visit|
      user_visit = user_visits.find{|visit| visit.utm_campaign == guest_visit.utm_campaign}

      if user_visit.present?
        user_visit.update_column(:visits, user_visit.visits.to_i + guest_visit.visits.to_i)
        guest_visit.delete
      else
        Marketing::UserVisit.where(id: guest_visit.id).update_all(
          user_token: nil, spree_user_id: user.id
        )
      end
    end

    # sync subscription data
    Marketing::Subscriber.new(user: user).create

    true
  end
end
