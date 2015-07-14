jQuery(document).ready(function($){
	var searchBtn = $('.search');
	var searchBox = $('.search-bar');
	var close = $('.close-search');
	var navMenu = $('.nav-menu');
	var searchArrow = $('.search-arrow');
	var shopBtn = $('.shop');

	function removeSearchBox () {
		searchBox.removeClass( "vis" );
	  	searchBox.addClass( "invis" );
	  	searchArrow.removeClass( "full-opacity" );
	}

	searchBtn.click(function() {
	  	searchBox.toggleClass( "vis" );
	  	// navMenu.toggleClass( "transparent-bg", false);
	  	// navMenu.toggleClass( "artificial-white-bg" );
			$('#input-search').focus();
	  	searchArrow.toggleClass( "full-opacity" );
	});

	close.click(function() {
		// navMenu.removeClass( "artificial-white-bg" );
		// navMenu.addClass( "transparent-bg" );
		removeSearchBox();

	});

	shopBtn.hover(function() {
		// If nav has artificial-white-bg class, remove
		// if (navMenu.hasClass( "artificial-white-bg" )) {
		// 	navMenu.removeClass( "artificial-white-bg" );
		// }
	  	removeSearchBox();
	});

});


////////////
// ALERTS
////////////

navAlertClass = $('.nav-alert-top');
alert = $('.alert');
pageTitle = $('.page-title');
slider = $('#theTarget');


function addAlertHeightToNav() {
	var alertHeight = alert.outerHeight();
	// Changing top margin of fixed nav based on alert size
	navAlertClass.css("top", alertHeight);
	pageTitle.css("margin-top", 70+alertHeight);
	slider.css("margin-top", 70+alertHeight);
}

jQuery(document).ready(function($){

	alertFixed = $('.alert-fixed-top');
	navMenu = $('.nav-menu');
	pageTitle = $('.page-title');
	slider2 = $('#theTarget');
	alertFixed.removeClass('isClosed');
	alertFixed.addClass('isOpen');

	// Alert functionality
	alertFixed.on('closed.bs.alert', function () {

  		alertFixed.addClass('display-none');
  		navMenu.removeClass('nav-alert-top');
  		navMenu.css('top', '0');
  		pageTitle.css('margin-top', '70');
  		slider2.css('margin-top', '70');
  		alertFixed.removeClass('isOpen');
  		alertFixed.addClass('isClosed');
	})

	addAlertHeightToNav();

});

$(window).resize(function() {
	// If alert is displayed
	if (alert.hasClass('isOpen')) {
		addAlertHeightToNav();
	}

});

jQuery(document).ready(function($){
	var style = $('.style');
	var overlay = $('.mobile-menu-overlay');

	style.click(function() {
		overlay.toggleClass('mobile-show');
	});

});
