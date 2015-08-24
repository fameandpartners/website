#{div,span,b,label,input} = React.DOM
#
#@ReactCheckbox = React.createClass
  #getInitialState: ->
    #checked: @props.name == ''
#
  #check: ->
    #@setState({checked: !@state.checked})
#
  #render: ->
    #input
      #type: 'checkbox'
      #checked: @state.checked
      #onChange: @check
      #name: @props.name
#
#@aaaCollectionFilter = React.createClass
#
  #topMenu: ->
    #div
      #className: ''
      #div
        #className: ''
        #"Home / "
        #b
          #className: ''
          #"Dresses"
#
  #filterRect: ->
    #div
      #className: 'filterRect'
      #span
        #className: 'filterText'
        #"Filter"
      #span
        #className: 'clearAll'
        #b
          #className: ''
          #"Clear all"
#
  #filterStyle: ->
    #div
      #className: ''
      #b
        #className: 'filterHead'
        #"STYLES"
      #div
        #className: 'filterArea filterAreaStyles'
        #div
          #className: 'filterOption'
          #label
            #className: ''
            #React.createElement ReactCheckbox, name: ''
            #"View all styles"
        #for i in [0..@props.styles.length-1]
          #div
            #className: 'filterOption'
            #label
              #className: ''
              #React.createElement ReactCheckbox, name: @props.styles[i].table.name
              #@props.styles[i].table.name
#
#
  #filterColor: ->
    #div
      #className: ''
      #b
        #className: 'filterHead'
        #"COLORS"
      #div
        #className: 'filterArea filterAreaColors'
        #div
          #className: 'filterOption'
          #label
            #className: ''
            #React.createElement ReactCheckbox, name: ''
            #"View all colors"
        #for i in [0..@props.colors.length-1]
          #div
            #className: 'filterOption'
            #label
              #className: ''
              #React.createElement ReactCheckbox, name: @props.colors[i].table.presentation
              #@props.colors[i].table.presentation
#
  #filterShape: ->
    #div
      #className: ''
      #b
        #className: ''
        #"SHAPES"
      #div
        #className: 'filterArea filterAreaShapes'
        #div
          #className: 'filterOption'
          #label
            #className: ''
            #React.createElement ReactCheckbox, name: ''
            #"View all shapes"
        #for i in [0..@props.shapes.length-1]
          #div
            #className: 'filterOption'
            #label
              #className: ''
              #React.createElement ReactCheckbox, name: @props.shapes[i]
              #@props.shapes[i]
#
  #render: ->
    #div
      #className: ''
      #@topMenu()
      #@filterRect()
      #@filterStyle()
      #@filterColor()
      #@filterShape()
