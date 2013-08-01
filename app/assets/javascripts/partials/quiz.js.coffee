$ ->
  window.showStyleQuiz = ->
    $(".quiz-box").show()
    $("body").css "overflow", "hidden"
    $.getScript "/quiz"
    $('.quiz-overlay').one('click', hideStyleQuiz)

  window.hideStyleQuiz = ->
    $(".quiz-box").hide()
    $("body").css "overflow", "auto"

  window.bindStyleQuizEvents = ->
    $(".quiz-box").on "click", (event) ->
      event.stopPropagation()

    $(".quiz-box .close-quiz").on "click", () ->
      hideStyleQuiz()

    $(document).keyup (event) ->
      if event.which is 27
        $(document).off "keyup"
        $("#wrap").off "click"
        hideStyleQuiz()

    $("#wrap").on "click", (event) ->
      $("#wrap").off "click"
      $(document).off "keyup"
      hideStyleQuiz()

  window.startStyleQuizClickHandler = (e) ->
    e.preventDefault()
    e.stopPropagation()
    showStyleQuiz()
    bindStyleQuizEvents()

  $("a.show-style-quiz").on "click", startStyleQuizClickHandler

  $(".quiz-box .film-frame").find(":checkbox, :radio").on "change", (event) ->
    $form = $(event.target).parents("form")
    $form.find("li:not(:has(:input:checked))").removeClass "active"
    $form.find("li:has(:input:checked)").addClass "active"
