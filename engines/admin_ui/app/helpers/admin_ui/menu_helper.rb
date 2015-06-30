module AdminUi
  module MenuHelper
    def menu_item(link, title, icon: 'file', exact: false)
      active_opts = exact ? { active: :exact } : { }
      render 'admin_ui/core/single_menu_item', {
                                               link:        link,
                                               title:       title,
                                               icon:        icon,
                                               active_opts: active_opts
                                             }
    end
  end
end
