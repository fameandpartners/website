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
    @allCheckboxes = $(".filter-area .thumb")
    @allCheckboxes.on 'click', (e) =>
      @handleCheckboxes(e)
      @update()
    @selectColor = $(".select-color select")
    @selectColor.on 'change', (e) =>
      @handleCheckboxes(e)
      @update()

    @clearAll = $(".filter-rect .clear-all")
    @clearAll.on('click',@clearAllOptions)
    $(".show-more-styles").on 'click', ->
      if $(this).text() == "More"
        $(this).text("Less")
        $('.filter-area-styles').removeClass('short-height')
        $('.filter-area-styles').addClass('full-height')
      else
        $(this).text("More")
        $('.filter-area-styles').removeClass('full-height')
        $('.filter-area-styles').addClass('short-height')

    $('.select-color select').select2();
    $('.filter-area-colors .select2-selection--single').css('padding-top','7px')
    $("#filter-mobile").on 'click', ->
      $('.filter-col').toggleClass("slide-in")
    $(".filter-rect .close").on 'click', ->
      $('.filter-col').toggleClass("slide-in")

    $(document).on 'click', (e) ->
      close = $('.filter-col .close')
      closeX = close.position().left + close.width() + 20
      $('.filter-col').removeClass("slide-in") if e.clientX > closeX and $('.filter-col').hasClass("slide-in")

   $(document).on('mousedown touchstart', (e) =>
      if e.originalEvent.changedTouches?
        @xDown = e.originalEvent.changedTouches[0].screenX
    ).on 'mouseup touchend', (e2) =>
      if e2.originalEvent.changedTouches?
        @xUp = e2.originalEvent.changedTouches[0].screenX
        if @xDown > @xUp and $('.filter-col').hasClass("slide-in")
          $('.filter-col').removeClass("slide-in")


  clearAllOptions: =>
    $(".thumb").removeClass("thumb-true").addClass("thumb-false")
    $(".filter-area-colors .thumb-false[name='all']").removeClass("thumb-false").addClass("thumb-true")
    $(".filter-area-styles .thumb-false[name='all']").removeClass("thumb-false").addClass("thumb-true")
    $(".filter-area-shapes .thumb-false[name='all']").removeClass("thumb-false").addClass("thumb-true")
    $('.select-color select').val("none").trigger("change")
    @update()

  handleCheckboxes: (e) =>
    name = $(e.target).attr("name")
    area = $(e.target).closest(".filter-area")
    isColorCheckbox = area.hasClass("filter-area-colors")
    isShapeCheckbox = area.hasClass("filter-area-shapes")
    isStyleCheckbox = area.hasClass("filter-area-styles")
    isSelect = $(e.target).parent().hasClass("select-color")

    if isSelect
      name = $($('.filter-area-colors select option:selected')[0]).attr("name")
      return if name=="none"
      if $(".filter-area-colors .thumb-true[name='"+ name+"']").size() == 0
        $(".filter-area-colors .thumb[name='"+ name+"']").click()
      if $(".filter-area-colors .thumb-true[name='all']").size() == 1
          $(".filter-area-colors .thumb-true[name='all']").click()

    if (isColorCheckbox && !isSelect) || isShapeCheckbox || isStyleCheckbox
      checked = $(e.target).hasClass("thumb-true")
      $(e.target).toggleClass("thumb-true thumb-false")

    if isColorCheckbox && !isSelect
      if name == 'all'
        return if $(".filter-area-colors .thumb-false[name='all']").size() == 1
        $(".filter-area-colors .thumb-true[name!='all']").click()
        $('.select-color select').val("none").trigger("change")
      else
        if $(".filter-area-colors .thumb-true[name='all']").size() == 1 && !checked
          $(".filter-area-colors .thumb-true[name='all']").click()

    if isShapeCheckbox
      if name == 'all'
        return if $(".filter-area-shapes .thumb-false[name='all']").size() == 1
        $(".filter-area-shapes .thumb-true[name!='all']").click()
      else
        if $(".filter-area-shapes .thumb-true[name='all']").size() == 1 && !checked
          $(".filter-area-shapes .thumb-true[name='all']").click()

    if isStyleCheckbox
      if name == 'all'
        return if $(".filter-area-styles .thumb-false[name='all']").size() == 1
        $(".filter-area-styles .thumb-true[name!='all']").click()
      else
        if $(".filter-area-styles .thumb-true[name='all']").size() == 1 && !checked
          $(".filter-area-styles .thumb-true[name='all']").click()

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

    if $(".filter-area-colors .thumb-true[name='all']").size() == 0
      colorInputs = $(".filter-area-colors .thumb-true[name!='all']")
      for colorInput in colorInputs
        colourArray.push($(colorInput).attr("name"))
      colour = $(".filter-area-colors select option:selected").attr("name")
      if colour != "none"
        colourArray.push(colour)

    if $(".filter-area-shapes .thumb-true[name!='all']")[0]?
      bodyshapeInputs = $(".filter-area-shapes .thumb-true[name!='all']")
      for bodyshapeInput in bodyshapeInputs
        bodyshapeArray.push($(bodyshapeInput).attr("name"))

    if $(".filter-area-styles .thumb-true[name!='all']")[0]?
      styleInputs = $(".filter-area-styles .thumb-true[name!='all']")
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
