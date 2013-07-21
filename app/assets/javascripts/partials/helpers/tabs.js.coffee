window.helpers or= {}
window.helpers.tabs or= {}

# define tabbed content handler
# options for tabbed content
#  defaultOptions = {
#    selected: 'active' - will be assigned to selected class
#    tabs: 'tabs-links' - tabs itself
#    content: 'tab-content' - tabs content
#  }

window.helpers.enableTabs = (elements, options = {}) ->
  defaultOptions = {
    selected: 'active'
    tabs: 'tabs-links'
    content: 'tab-content'
  }
  options = _.extend({}, defaultOptions, options)
  elements.each((index, element) ->
    window.helpers.enableTab($(element), options)
  )

window.helpers.enableTab = (element, options) ->
  element.find(".#{options.tabs} li a").on('click', (e) ->
    e.preventDefault()

    # highligh tabs
    $(e.currentTarget)
      .closest("li")
      .addClass(options.selected)
      .siblings().removeClass(options.selected)

    # show tab content
    tabId = $(e.currentTarget).attr('href')

    check_anchor_regexp = /(\#|\.)\w+$/
    if check_anchor_regexp.test(tabId)
      element.find(".#{options.content}#{tabId}").show()
        .siblings(".#{options.content}").hide()
    else
      # invalid href
      return false
  )
  # imitate first tab selecting
  element.find(".#{options.tabs} a").first().click()
