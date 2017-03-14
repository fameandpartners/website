module Users
  module ReturnsHelper
    def line_item_presenter(line_item)
      Orders::LineItemPresenter.new(line_item)
    end
  end
end
