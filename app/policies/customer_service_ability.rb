class CustomerServiceAbility
  include CanCan::Ability

  # can [:admin, :manage, :edit, :index, :show, :destroy, :create, :update, :new], Spree::Order
  # can [:admin, :manage, :edit, :index, :show, :destroy, :create, :update, :new], Spree::Shipment

  def initialize(user)
    if user.has_spree_role?('Customer Service')
      can :admin, Spree::Order
      can :manage, Spree::Order
      can :index, Spree::Order
      can :read, Spree::Order
      can :show, Spree::Order
      can :new, Spree::Order
      can :create, Spree::Order
      can :edit, Spree::Order
      can :update, Spree::Order
      can :destroy, Spree::Order

      can :admin, Spree::Shipment
      can :manage, Spree::Shipment
      can :index, Spree::Shipment
      can :read, Spree::Shipment
      can :show, Spree::Shipment
      can :new, Spree::Shipment
      can :create, Spree::Shipment
      can :edit, Spree::Shipment
      can :update, Spree::Shipment
      can :destroy, Spree::Shipment

      can :admin, Spree::LineItem
      can :update, Spree::LineItem

      can :index, Spree::User
      can :read, Spree::User
      can :show, Spree::User
    end
  end

end
