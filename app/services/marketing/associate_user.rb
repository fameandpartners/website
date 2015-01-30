module Marketing; end

class Marketing::UserVisits
  def self.asssociate_with_user_by_token(options = {})
    user  = options[:user]
    token = options[:token]

    return false if (user.blank? || token.blank?)

    scope = Marketing::UserVisit.where(user_token: token).where(spree_user_id: nil)
    return false if !scope.exists?

    scope.update_all(spree_user_id: user.id, user_token: nil)

    true
  end
end
