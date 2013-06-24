$(".products.show").ready ->
  # define tabbed content handler
  enableTabs = (elements, options = {}) ->
    defaultOptions = {
      selected: 'active'
      tabs: 'tabs-links'
      content: 'tab-content'
    }
    options = _.extend({}, defaultOptions, options)
    elements.each((index, element) ->
      enableTab($(element), options)
    )

  enableTab = (element, options) ->
    element.find(".#{options.tabs} li a").bind('click', (e) ->
      e.preventDefault()

      # highligh tabs
      $(e.currentTarget)
        .closest("li")
        .addClass(options.selected)
        .siblings().removeClass(options.selected)

      # show tab content
      tabId = $(e.currentTarget).attr('href')
      element.find(".#{options.content}#{tabId}").show()
        .siblings(".#{options.content}").hide()
    )
    # imitate first tab selecting
    element.find(".#{options.tabs} a").first().click()


  # options for tabbed content
  #  defaultOptions = {
  #    selected: 'active' - will be assigned to selected class
  #    tabs: 'tabs-links' - tabs itself
  #    content: 'tab-content' - tabs content
  #  }

  # enable tabs where needed
  enableTabs($('.tabs'))
