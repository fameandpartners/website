window.helpers or= {}

window.helpers.get_vertical_carousel_options = (options = {}) ->
  prev = _.extend({ button: "#product-images-up", key: "up", items: 4 }, options.prev || {})
  next = _.extend({ button: "#product-images-down", key: "down", items: 4 }, options.next || {})

  result = _.extend(
    { direction: "up", items: 4, circular: false, infinite: false, auto: false },
    options,
    { prev: prev },
    { next: next }
  )

  return result


window.helpers.get_horizontal_carousel_options = (options = {}) ->
  prev = _.extend({ button: "#product-items-prev", key: "left", items: 4 }, options.prev || {})
  next = _.extend({ button: "#product-items-next", key: "right", items: 4 }, options.next || {})

  result = _.extend(
    { items: 4, width: 1094, circular: false, infinite: false, auto: false},
    options,
    { prev: prev },
    { next: next }
  )

  return result
