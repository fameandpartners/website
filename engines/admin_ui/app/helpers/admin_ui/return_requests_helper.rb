module AdminUi
  module ReturnRequestsHelper
    def action_class(action)
      {
        keep:     { icon: 'fa-smile-o',     alert: 'success'},
        exchange: { icon: 'fa-exchange',    alert: 'warning'},
        return:   { icon: 'fa-thumbs-down', alert: 'danger' },
        delete:   { icon: 'fa-gears' },
        edit:     { icon: 'fa-pencil-square-o' }
      }[action.to_sym]
    end

    def action_icon_class(action)
      "fa #{action_class(action)[:icon]}"
    end

    def action_alert_class(action)
      "alert alert-#{action_class(action)[:alert]}"
    end
  end
end
