window.helpers or= {}

window.helpers.buildLoadingIndicator = (container, options = {}) ->
  container = container

  if options.indicator_type == 'spinner'
    indicator = {
      element: null
      rootElement: null
      spinner: null

      getSpinnerImage: () ->
        $("<img />", {src: '/assets/spinner-big.gif'})

      showLoading: () ->
        indicator.spinner = indicator.getSpinnerImage()
        container.hide().after(indicator.spinner)

      hideLoading: () ->
        container.show()
        indicator.spinner.remove()
    }

  else
    indicator = {
      previousText: null
      loadingText: options.message || 'adding...'

      showLoading: () ->
        indicator.previousText = container.text()
        container.attr('disabled', true).text(indicator.loadingText)

      hideLoading: () ->
        indicator.previousState = container.text()
        if container.text() == indicator.loadingText
          container.removeAttr('disabled').text(indicator.previousText)
    }

  return indicator
