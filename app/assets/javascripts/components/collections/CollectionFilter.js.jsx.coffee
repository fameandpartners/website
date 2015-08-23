DOM = React.DOM
@CollectionFilter = React.createClass

  topMenu: ->
    DOM.div
      className: ''
      DOM.div
        className: ''
        "Home / "
        DOM.b
          className: ''
          "Dresses"

  filterRect: ->
    DOM.div
      className: 'filterRect'
      DOM.span
        className: 'filterText'
        "Filter"
      DOM.span
        className: 'clearAll'
        DOM.b
          className: ''
          "Clear all"

  filterStyle: ->
    DOM.div
      className: ''
      DOM.b
        className: 'filterHead'
        "STYLES"
      DOM.div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.styles.length)]
          DOM.div
            className: 'filterOption'
            DOM.label
              className: ''
              DOM.input
                type: 'checkbox'
              @props.styles[i].table.name

  filterColor: ->
    DOM.div
      className: ''
      DOM.b
        className: 'filterHead'
        "COLORS"
      DOM.div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.colors.length)]
          DOM.div
            className: 'filterOption'
            DOM.label
              className: ''
              DOM.input
                type: 'checkbox'
              @props.colors[i].table.presentation

  filterShape: ->
    DOM.div
      className: ''
      DOM.b
        className: ''
        "SHAPES"
      DOM.div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.shapes.length)]
          DOM.div
            className: 'filterOption'
            DOM.label
              className: ''
              DOM.input
                type: 'checkbox'
              @props.shapes[i]

  render: ->
    DOM.div
      className: ''
      @topMenu()
      @filterRect()
      @filterStyle()
      @filterColor()
      @filterShape()
