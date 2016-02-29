jQuery(document).ready(function($){
	var searchInput = $('#input-search');
	var searchBtn   = $('.search');
	var close       = $('.close-search');
	var shopBtn     = $('.shop');

	searchBtn.click(function() {
		searchInput.focus();
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
