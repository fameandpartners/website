$(function(){
  window.productWishlist.initialize();

  $('form .size-choser :radio').change(function(event){
    $('form .size-choser li').removeClass('active');
    $(event.target).parents('li:first').addClass('active');
  });

  $('form .size-choser li:has(:radio:checked)').addClass('active');

  window.initHoverableProductImages();

  // have disabled this plugin - we don't have abbr.timeago on pages
  //$("abbr.timeago").timeago();
});

$('.ecommerce').ready(function(){
  $(document).on('click', '.ask-parent-to-pay-button', function(e){
    e.preventDefault();
    paymentRequestModal.show();
    if (window.shoppingBag) window.shoppingBag.hide();
  });
});


$(function() {
  // :not selector required to prevent applying chosen on chosen child elements
  // this will break js code

  $('.selectbox.chosen-inherit').not('.chosen-container').chosen({
    width: '100%',
    inherit_select_classes: true,
    disable_search: true
  });

  $('.selectbox').not('.chosen-container').not('.chosen-inherit').chosen({
    width: '100%',
    disable_search: true
  });

  $('.nav-user li:has(.dropdown)').hover(
    function() {
      $(this).find('.dropdown').stop(true, true).fadeIn('fast');
    }, 
    function() {
      $(this).find('.dropdown').stop(true, true).fadeOut('fast');
    }
  );

  $('.dropdown-trigger').hover(
    function() {
      $(this).find('.dropdown-menu').stop(true, true).fadeIn('fast');
    },
    function() {
      $(this).find('.dropdown-menu').stop(true, true).fadeOut('fast');
    }
  );
/*
  // TODO Need to refactor to new popup style
  window.showNewsletterPopup = function (event) {
    if (event != undefined) event.preventDefault();

    $popupWrapper = $(".campaign-newsletter");
    $popupContent = $popupWrapper.find('.modal-container');
    popup = new window.popups.newsletterModalPopup();
    popup.initialize($popupWrapper.first());
    popup.show();
    $popupContent.center();
    window.newsletterModalPopup = popup;
    return popup;
  }

  $('a.btn.newsletter').click(showNewsletterPopup);
*/

  $('a.btn.newsletter').on('click', function(e) {
    e.preventDefault();
    popup = new window.popups.NewsletterModalPopup();
    popup.show();
    return true;
  });

  zoomObj = $('.picture.product');
  zoomObj.zoom({});
});
