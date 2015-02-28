class Activity < ActiveRecord::Base
  validates :owner_id, :owner_type, presence: true

  validates :action, inclusion: { in: %w{viewed purchased added_to_cart added_to_wishlist quiz_started}}

  serialize :info, Hash

  attr_accessible :action, :owner_id, :owner_type, :item_id, :item_type, :actor_id, :actor_type

  %w{owner actor item}.each do |name|
    define_method name.to_s do
      if self.attributes["#{name}_type"].present? && self.attributes["#{name}_id"].present?
        self.attributes["#{name}_type"].constantize.find(self.attributes["#{name}_id"])
      end
    end

    define_method "#{name}=" do |new_value|
      if new_value.present?
        self.send("#{name}_type=", new_value.class.to_s)
        self.send("#{name}_id=", new_value.id)
      end
    end
  end

  class << self
    def log_product_viewed(product, session_key = nil, user = nil)
      session_key ||= 'user_without_session_key'
      args = {
        action: 'viewed',
        owner_id: product.id, owner_type: product.class.to_s
      }
      if user.present?
        args.update({ actor_id: user.id, actor_type: user.class.to_s })
      else
        args.update({ session_key: session_key })
      end

      activity = Activity.where(args).first_or_initialize
      activity.number = activity.number.to_i + 1
      if user.present?
        activity.info = user.reservation_info
      end
      activity.save
    end

    def log_product_purchased(product, user = nil, order = nil)
      args = {
        action: 'purchased',
        owner_id: product.id, owner_type: product.class.to_s,
        item_id: order.id, item_type: order.class.to_s
      }
      activity = Activity.new(args)
      activity.info = { first_name: order.user_first_name, last_name: order.user_last_name }
      if user.present?
        activity.actor = user
        activity.info.merge!(user.reservation_info(product))
      end
      activity.save
    end

    # all attributes required
    def log_product_added_to_wishlist(product, user, item)
      args = {
        action: 'added_to_wishlist',
        owner_id: product.id, owner_type: product.class.to_s,
        actor_id: user.id,    actor_type: user.class.to_s,
        item_id:  item.id,    item_type: item.class.to_s
      }
      activity = Activity.where(args).first_or_initialize
      activity.info   = user.reservation_info(product)
      activity.number = activity.number.to_i + 1
      activity.save
    end

    def log_product_added_to_cart(product, session_key = nil, user = nil, order = nil)
      session_key ||= 'user_without_session_key'
      args = {
        action: 'added_to_cart',
        owner_id: product.id, owner_type: product.class.to_s,
        item_id: order.id, item_type: order.class.to_s
      }
      activity = Activity.where(args).first_or_initialize
      activity.number = activity.number.to_i + 1
      if user.present?
        activity.actor = user
        activity.info = user.reservation_info(product)
      else
        activity.session_key = session_key
      end
      activity.save
    rescue Exception => e
      # do nothing
    end

    def log_quiz_started(quiz, user)
      args = {
        action: 'quiz_started'
      }

      Activity.create(args) do |object|
        object.actor = user
        object.owner = quiz
      end
    end

    def replace_temporary_keys(session_key, user)
      return if session_key.blank? || user.blank?
      reservation_info = user.reservation_info
      Activity.where(session_key: session_key).each do |record|
        record.session_key  = nil
        record.actor        = user
        record.info         = user.reservation_info
        record.save
      end
    end
  end
end
