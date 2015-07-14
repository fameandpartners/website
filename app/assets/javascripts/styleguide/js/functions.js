jQuery(document).ready(function($){
	var searchInput = $('#input-search');
	var searchBtn   = $('.search');
	var searchBox   = $('.search-bar');
	var close       = $('.close-search');
	var shopBtn     = $('.shop');

	function removeSearchBox () {
		searchBox.removeClass("vis").addClass("invis");
	}

	searchBtn.click(function() {
	  	searchBox.toggleClass("vis");
		searchInput.focus();
	});

	close.click(function() {
		removeSearchBox();
	});

	shopBtn.hover(function() {
	  	removeSearchBox();
	});
});


////////////
// ALERTS
////////////

jQuery(document).ready(function($){
	var style = $('.style');
	var overlay = $('.mobile-menu-overlay');

	style.click(function() {
		overlay.toggleClass('mobile-show');
	});
});
