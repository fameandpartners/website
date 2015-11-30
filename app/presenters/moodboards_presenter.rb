require 'delegate'

class MoodboardsPresenter
  attr_reader :moodboards
  def initialize(user)
    if user
      if user.moodboards.empty?
        user.moodboards.default_or_create
      end
      @moodboards = user.moodboards
    else
      @moodboards = []
    end
  end

  def as_json(*opts)
    {
      moodboards: moodboards.map { |mb| MoodboardPresenter.new(mb) },
      default:    default
    }
  end

  def default
    MoodboardPresenter.new(moodboards.detect {|m| m.default? })
  end

  class MoodboardPresenter < SimpleDelegator
    def as_json(*opts)
      {
        id:            id,
        name:          name,
        purpose:       purpose,
        items:         presented_items,
        show_path:     show_path,
        add_item_path: add_item_path,
      }
    end

    def presented_items
      items.active.map do |item|
        {
          variant_id: item.variant_id,
          product_id: item.product_id,
          color_id:   item.color_id
        }
      end
    end

    def show_path
      Rails.application.routes.url_helpers.moodboard_path(self.__getobj__)
    end

    def add_item_path
      Rails.application.routes.url_helpers.moodboard_items_path(self.__getobj__)
    end
  end
end
