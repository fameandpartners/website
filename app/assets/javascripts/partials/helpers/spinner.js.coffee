window.helpers or= {}

window.helpers.startSpinner = (target) ->

  opts =
    lines: 11 # The number of lines to draw
    length: 21 # The length of each line
    width: 7 # The line thickness
    radius: 32 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    rotate: 79 # The rotation offset
    direction: 1 # 1: clockwise, -1: counterclockwise
    color: "#000" # #rgb or #rrggbb or array of colors
    speed: 0.9 # Rounds per second
    trail: 41 # Afterglow percentage
    shadow: false # Whether to render a shadow
    hwaccel: false # Whether to use hardware acceleration
    className: "spinner" # The CSS class to assign to the spinner
    zIndex: 2e9 # The z-index (defaults to 2000000000)
    top: "50%" # Top position relative to parent
    left: "50%" # Left position relative to parent

  target = $(target)
  spinner = new Spinner(opts).spin(target)