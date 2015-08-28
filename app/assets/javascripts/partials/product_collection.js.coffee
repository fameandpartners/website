#= require 'templates/_product'
#= require 'templates/product_collection'
#= require 'templates/product_collection_append'

window.page or= {}
window.ProductCollectionFilter = class ProductCollectionFilter
  filter: null
  content: null
  updateParams: {}
  collectionTemplate: JST['templates/product_collection']
  collectionMoreTemplate: JST['templates/product_collection_append']

  constructor: (options = {}) ->
    options = $.extend({
      reset_source: true,
      page_size: 21,
      showMoreSelector: "*[data-action=show-more-collection-products]"
		}, options)

    @details_elements = options.details_elements || {}
    @filter = $(options.controls)
    @content = $(options.content)

    # base
    # if users comes by url with specific params, like /dresses/for/very/special/case
    # then use this path until user selects another collection
    @source_path = window.location.pathname || '/dresses'

    # allow user to leave /dresses/for/very/special/case collection
    # or navigate only in it
    @reset_source = options.reset_source

    # pagination
    @page_size = options.page_size
    @resetPagination(options.size, options.total_products)
    @showMoreSelector = options.showMoreSelector
    @content.on('click', @showMoreSelector, @showMoreProductsClickHandler)
    $(window).on('scroll', @scrollHandler)

    @productOrderInput  = new inputs.ProductOrderSelector(container: @filter.find('#product_order'))

    @setUpFilterElements()
    @productOrderInput.on('change', @update)

    @$banner = $(options.banner)
    @setBannerTextClass()
    @content.find('.img-product').hoverable()

  setUpFilterElements: =>
    @allCheckboxes = $(".filterArea .thumb")
    @allCheckboxes.on 'click', (e) =>
      @handleCheckboxes(e)
      @update()
    @selectColor = $(".selectColor select")
    @selectColor.on 'change', (e) =>
      @handleCheckboxes(e)
      @update()

    @clearAll = $(".filterRect .clearAll")
    @clearAll.on('click',@clearAllOptions)
    $(".showMoreStyles").on 'click', ->
      if $(this).text() == "More"
        $(this).text("Less")
        $('.filterAreaStyles').removeClass('shortHeight')
        $('.filterAreaStyles').addClass('fullHeight')
      else
        $(this).text("More")
        $('.filterAreaStyles').removeClass('fullHeight')
        $('.filterAreaStyles').addClass('shortHeight')

    $('.selectColor select').select2();
    $('.filterAreaColors .select2-selection--single').css('padding-top','7px')
    $("#filterMobile").on 'click', ->
      $('.filterCol').toggleClass("slideIn")
    $(".filterRect .close").on 'click', ->
      $('.filterCol').toggleClass("slideIn")

    $(document).on 'click', (e) ->
      close = $('.filterCol .close')
      closeX = close.position().left + close.width() + 20
      $('.filterCol').removeClass("slideIn") if e.clientX > closeX and $('.filterCol').hasClass("slideIn")

   $(document).on('mousedown touchstart', (e) =>
      if e.originalEvent.changedTouches?
        @xDown = e.originalEvent.changedTouches[0].screenX
    ).on 'mouseup touchend', (e2) =>
      if e2.originalEvent.changedTouches?
        @xUp = e2.originalEvent.changedTouches[0].screenX
        if @xDown > @xUp and $('.filterCol').hasClass("slideIn")
          $('.filterCol').removeClass("slideIn")


  clearAllOptions: =>
    $(".thumb").removeClass("thumbtrue").addClass("thumbfalse")
    $(".filterAreaColors .thumbfalse[name='all']").removeClass("thumbfalse").addClass("thumbtrue")
    $(".filterAreaStyles .thumbfalse[name='all']").removeClass("thumbfalse").addClass("thumbtrue")
    $(".filterAreaShapes .thumbfalse[name='all']").removeClass("thumbfalse").addClass("thumbtrue")
    @update()

  handleCheckboxes: (e) =>
    name = $(e.target).attr("name")
    area = $(e.target).closest(".filterArea")
    isColorCheckbox = area.hasClass("filterAreaColors")
    isShapeCheckbox = area.hasClass("filterAreaShapes")
    isStyleCheckbox = area.hasClass("filterAreaStyles")
    isSelect = $(e.target).parent().hasClass("selectColor")

    if isSelect
      name = $($('.filterAreaColors select option:selected')[0]).attr("name")
      return if name=="none"
      if $(".filterAreaColors .thumbtrue[name='"+ name+"']").size() == 0
        $(".filterAreaColors .thumb[name='"+ name+"']").click()
      if $(".filterAreaColors .thumbtrue[name='all']").size() == 1
          $(".filterAreaColors .thumbtrue[name='all']").click()

    if (isColorCheckbox && !isSelect) || isShapeCheckbox || isStyleCheckbox
      checked = $(e.target).hasClass("thumbtrue")
      if checked
        $(e.target).removeClass("thumbtrue")
        $(e.target).addClass("thumbfalse")
      else
        $(e.target).removeClass("thumbfalse")
        $(e.target).addClass("thumbtrue")

    if isColorCheckbox && !isSelect
      if name == 'all'
        return if $(".filterAreaColors .thumbfalse[name='all']").size() == 1
        $(".filterAreaColors .thumbtrue[name!='all']").click()
      else
        if $(".filterAreaColors .thumbtrue[name='all']").size() == 1 && !checked
          $(".filterAreaColors .thumbtrue[name='all']").click()

    if isShapeCheckbox
      if name == 'all'
        return if $(".filterAreaShapes .thumbfalse[name='all']").size() == 1
        $(".filterAreaShapes .thumbtrue[name!='all']").click()
      else
        if $(".filterAreaShapes .thumbtrue[name='all']").size() == 1 && !checked
          $(".filterAreaShapes .thumbtrue[name='all']").click()

    if isStyleCheckbox
      if name == 'all'
        return if $(".filterAreaStyles .thumbfalse[name='all']").size() == 1
        $(".filterAreaStyles .thumbtrue[name!='all']").click()
      else
        if $(".filterAreaStyles .thumbtrue[name='all']").size() == 1 && !checked
          $(".filterAreaStyles .thumbtrue[name='all']").click()

  resetPagination: (items_on_page, total_records) ->
    @products_on_page = items_on_page
    @total            = total_records
    @updatePaginationLink('active')

  updatePagination: (items_added, total_records) ->
    if items_added == 0
      @products_on_page = total_records
    else
      @products_on_page += items_added
    @total            = total_records
    @updatePaginationLink('active')

  updatePaginationLink: (state = 'active') ->
    row = @content.find(@showMoreSelector).closest('.row.more-products')
    row.find('.status').hide()
    if state == 'loading'
      row.find('.loading').show()
    else if state == 'inactive'
      row.find('.inactive').show()
    else # active
      if @products_on_page < @total
        row.find('.active').show()
      else
        row.find('.inactive').show()

  update: () =>
    @source_path = '/dresses' if @reset_source
    updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
    pageUrl = @updatePageLocation(updateRequestParams)

    @updatePaginationLink('inactive')
    $.ajax(urlWithSitePrefix(@source_path),
      type: "GET",
      dataType: 'json',
      data: $.param(_.extend(updateRequestParams, { limit: @page_size })),
      success: (collection) =>
        content_html = @collectionTemplate(collection: collection)
        @content.html(content_html)
        @content.find('.img-product').hoverable()

        @resetPagination(collection.products.length, collection.total_products)

        if collection && collection.details
          @updateCollectionDetails(collection.details)

        track.pageView(pageUrl, updateRequestParams)
    )

  showMoreProductsClickHandler: (e) =>
    e.preventDefault()
    if @loading != true
      @loading = true
      updateRequestParams = _.extend({}, @updateParams, @getSelectedValues())
      @updatePaginationLink('loading')
      $.ajax(urlWithSitePrefix(@source_path),
        type: "GET",
        dataType: 'json',
        data: $.param(_.extend(updateRequestParams, { limit: @page_size, offset: @products_on_page })),
        success: (collection) =>
          content_html = @collectionMoreTemplate(collection: collection, col: 3)
          @content.find(@showMoreSelector).closest('.row.relative').before(content_html)
          @content.find('.img-product').hoverable()
          # @updatePagination(collection.products.length, collection.total_products)
          @updatePagination(collection.products.length, collection.total_products)

          if collection && collection.details
            @updateCollectionDetails(collection.details)
      ).always( =>
        @loading = false
      )

  # private methods

  addValue: (object, propertyName, elementSelector) ->
    propertyValue = @filter.find(elementSelector).val()
    object[propertyName] = propertyValue unless _.isEmpty(propertyValue)
    object

  getSelectedValues: () ->
    bodyshapeArray = []
    colourArray = []
    styleArray = []

    if $(".filterAreaColors .thumbtrue[name='all']").size() == 0
      colorInputs = $(".filterAreaColors .thumbtrue[name!='all']")
      for colorInput in colorInputs
        colourArray.push($(colorInput).attr("name"))
      colour = $($(".filterAreaColors select option:selected")[0]).attr("name")
      if colour != "none"
        colourArray.push(colour)

    if $(".filterAreaShapes .thumbtrue[name!='all']")[0]?
      bodyshapeInputs = $(".filterAreaShapes .thumbtrue[name!='all']")
      for bodyshapeInput in bodyshapeInputs
        bodyshapeArray.push($(bodyshapeInput).attr("name"))

    if $(".filterAreaStyles .thumbtrue[name!='all']")[0]?
      styleInputs = $(".filterAreaStyles .thumbtrue[name!='all']")
      for styleInput in styleInputs
        styleArray.push($(styleInput).attr("name"))

    {
      bodyshape: bodyshapeArray,
      colour:    colourArray,
      style:     styleArray,
      order:     @productOrderInput.val()
    }

  updatePageLocation: (filter) ->
    source = _.clone(@source_path)
    filter = _.compactObject(filter || {})
    if _.isEmpty(filter)
      url = source
    else
      url = "#{ source }?#{ $.param(filter) }"

    url = urlWithSitePrefix(url)
    window.history.pushState({ path: url }, '', url)
    url

  scrollHandler: (e) =>
    $el = $(@showMoreSelector)
    if $el.is(':visible')
      $window = $(window)
      top = $window.scrollTop()
      bottom = top + $window.height()

      elTop = $el.offset().top - 120 #load a bit early
      elBottom = elTop + $el.height();

      if ((elBottom <= bottom) && (elTop >= top))
        $el.click()

  updateCollectionDetails: (details) =>
    return if !@details_elements
    return if !details

    $('title').html(details.title) if details.title
    $('meta[name=description]').attr('content', details.description) if details.description

    if @details_elements.banner && details.banner
      $(@details_elements.banner.title).html(details.banner.title) if details.banner.title
      $(@details_elements.banner.description).html(details.banner.description) if details.banner.description

      if details.banner.image
        $banner_img = $(@details_elements.banner.image)
        image = new Image()
        image.onload = () -> $banner_img.css('background-image', "url('#{ details.banner.image }')")
        image.src = details.banner.image

  setBannerTextClass: () =>
    bgImg = @$banner.css('background-image')
    if bgImg && bgImg.indexOf('dark-bg.jpg') != -1
      @$banner.addClass('dark-bg')
