window.page or= {}

window.page.UserOrderReturner = class UserOrderReturner

  data = {
    different: ["Dress does not sit on the body as shown on the website", "Colour does not match the colour displayed on the website", "Fabric is different to what is represented on the website", "The dress simply didn't meet my expectations"],
    multiple: ["I was not sure which dress would suit me", "I was unsure of the best size for me", "I loved so many dresses I found it difficult to choose"],
    delivery: ["My order was late, so I missed my event", "The delivery times on the webiste were not clear", "My order was held up in transit", "I received a different size to what I ordered", "I received a different style to what I ordered", "I only received part of my order"],
    quality: ["Dress was damaged when it arrived", "Dress was a poor fit", "Dress had marks on it", "Fabric was poor quality", "Zipper was damaged ", "Dress was poorly made, in my opinion", "Lining fabric looked cheap", "I did not receive my customisation"],
    size:  ["Dress was too long", "Dress was too short", "Dress was too big around the bust", "Dress was too small around the bust", "Dress was too big around the waist", "Dress was too small around the waist", "Dress was too loose on the hips", "Dress was too tight on the hips", "Fit was unflattering", "Neckline was too low or too open", "Shoulder straps were too long", "Neck tie was too tight", "Shoulder pads fitted poorly", "I did not receive my customisation"]
  }


  constructor: (opts = {}) ->
    @$form = $(opts.form)

    $('.return-reason-category-container').hide()
    $('.return-reason-container').hide()

    selectOpts = {
        inherit_select_classes: true
        disable_search: true
    }

    $('.return-reason-select').chosen(selectOpts)
    $('.return-reason-select').hide()


    $('.return-action').chosen(selectOpts).change ->
      v = $(this).val();
      $p = $(this).parent()
      if v == "keep"
        $p.find('.return-reason-container').hide()
        $p.find('.return-reason-category-container').hide()
      else
        $p.find('.return-reason-category-container').show()

    $('.return-reason-category').chosen(selectOpts).change ->
      v = $(this).val().toLowerCase();
      $p = $(this).parent()

      $select = $p.find('select.return-reason-select')
      opts = switch v
        when "looks different to image on site"
          data.different
        when "ordered multiple styles or sizes"
          data.multiple
        when "delivery issues"
          data.delivery
        when "poor quality or faulty"
          data.quality
        when "size and fit"
          data.size
        else
          []

      $select.find('option').remove()
      $.each(opts, (key, value) ->
        $select.append($('<option>', { value : value }).text(value));
      )

      $select.trigger("chosen:updated")

      $p.find('.return-reason-container').show()
      $p.find('.chosen-container.return-reason-select').show()
