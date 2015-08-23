{div,span,b,label,input} = React.DOM
@CollectionFilter = React.createClass

  topMenu: ->
    div
      className: ''
      div
        className: ''
        "Home / "
        b
          className: ''
          "Dresses"

  filterRect: ->
    div
      className: 'filterRect'
      span
        className: 'filterText'
        "Filter"
      span
        className: 'clearAll'
        b
          className: ''
          "Clear all"

  filterStyle: ->
    div
      className: ''
      b
        className: 'filterHead'
        "STYLES"
      div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.styles.length)]
          div
            className: 'filterOption'
            label
              className: ''
              input
                type: 'checkbox'
              @props.styles[i].table.name

  filterColor: ->
    div
      className: ''
      b
        className: 'filterHead'
        "COLORS"
      div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.colors.length)]
          div
            className: 'filterOption'
            label
              className: ''
              input
                type: 'checkbox'
              @props.colors[i].table.presentation

  filterShape: ->
    div
      className: ''
      b
        className: ''
        "SHAPES"
      div
        className: 'filterArea'
        for i in [0..Math.min(6,@props.shapes.length)]
          div
            className: 'filterOption'
            label
              className: ''
              input
                type: 'checkbox'
              @props.shapes[i]

  render: ->
    div
      className: ''
      @topMenu()
      @filterRect()
      @filterStyle()
      @filterColor()
      @filterShape()
