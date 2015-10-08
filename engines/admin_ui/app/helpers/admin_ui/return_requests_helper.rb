module AdminUi
  module ReturnRequestsHelper
    def action_class(action)
      {
        keep:     { icon: 'fa-smile-o',     alert: 'success'},
        exchange: { icon: 'fa-exchange',    alert: 'warning'},
        return:   { icon: 'fa-thumbs-down', alert: 'danger' },
        cancellation: { icon: 'fa-ban',      alert: 'danger' },
        refund:       { icon: 'fa-dollar',   alert: 'danger' },
        unknown:      { icon: 'fa-question', alert: 'warning' },
        store_credit: { icon: 'fa-ticket',   alert: 'warning' },
        delete:   { icon: 'fa-gears' },
        edit:     { icon: 'fa-pencil-square-o' }
      }.fetch(action.to_sym) { { icon: 'fa-gears' } }
    end

    def action_icon_class(action)
      "fa #{action_class(action)[:icon]}"
    end

    def action_alert_class(action)
      "alert alert-#{action_class(action)[:alert]}"
    end
  end
end
