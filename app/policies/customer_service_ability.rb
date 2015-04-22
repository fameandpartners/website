class CustomerServiceAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Spree::User.new
    if user.has_spree_role?('customer_service')
      can :admin, Spree::Order
      can :manage, Spree::Order
      can :index, Spree::Order
      can :read, Spree::Order
      can :show, Spree::Order
      cannot :new, Spree::Order
      cannot :create, Spree::Order
      cannot :edit, Spree::Order
      cannot :update, Spree::Order
      cannot :destroy, Spree::Order

      can :admin, Spree::Shipment
      can :manage, Spree::Shipment
      can :index, Spree::Shipment
      can :read, Spree::Shipment
      can :show, Spree::Shipment
      cannot :new, Spree::Shipment
      cannot :create, Spree::Shipment
      cannot :edit, Spree::Shipment
      cannot :update, Spree::Shipment
      cannot :destroy, Spree::Shipment

    end
  end
end
