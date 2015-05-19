class Bridesmaid::MembershipsController < Bridesmaid::BaseController
  before_filter :require_completed_profile!

  def create
    event = bridesmaid_user_profile

    friends = params[:friends]
    errors  = {}

    memberships = Hash[*friends.map do |index, friend|
      first_name, last_name = friend[:full_name].split(' ')
      membership = event.members.build
      membership.first_name = first_name
      membership.last_name = last_name
      membership.email = friend[:email]

      [index, membership]
    end.flatten]

    ActiveRecord::Base.transaction do
      memberships.each do |index, membership|
        unless membership.save
          errors[index] = membership.errors.to_hash.slice(:email, :first_name, :last_name)
        end
      end

      unless memberships.values.all?(&:persisted?)
        raise ActiveRecord::Rollback
      end
    end

    if memberships.values.all?(&:persisted?)
      memberships.values.each do |membership|
        BridesmaidPartyMailer.delay.invite(membership)
      end

      respond_to do |format|
        format.html do
          redirect_to wishlist_path
        end
        format.json do
          render json: {}, status: :ok
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to wishlist_path
        end
        format.json do
          render json: { errors: errors }, status: :error
        end
      end
    end
  end
end
