$ ->
  $('#related_jackets_select2').select2
    placeholder: 'Associate Jackets (can only search for jackets)'
    minimumInputLength: 1
    multiple: true
    initSelection: (element, callback) ->
      url = Spree.url(Spree.routes.outerwear_search, ids: element.val())
      $.getJSON url, null, (data) ->
        jackets = $.map data, (result) -> result
        callback jackets
    ajax:
      url: Spree.routes.outerwear_search
      datatype: 'json'
      quietMillis: 200
      data: (term, page) -> { q: term }
      results: (data, page) -> { results: data }
    formatResult: (product) -> product.name
    formatSelection: (product) -> product.name
