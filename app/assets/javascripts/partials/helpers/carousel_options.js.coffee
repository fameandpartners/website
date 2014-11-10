window.helpers ||= {}

window.helpers.get_vertical_carousel_options = (options = {}) ->
  prev = _.extend({ button: "#product-images-up", key: "up", items: 3 }, options.prev || {})
  next = _.extend({ button: "#product-images-down", key: "down", items: 3 }, options.next || {})

  result = _.extend(
    { direction: "down", items: 3, circular: false, infinite: false, auto: false },
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
