jQuery(document).ready(function($) {

	// Homepage carousel setup
	var homepage_carousel = $('#myCarousel');

	if( homepage_carousel.length ) {

		homepage_carousel.carousel({
			interval: false
		})

		homepage_carousel.touchwipe({
	          wipeLeft: function() { jQuery("#myCarousel").carousel('next'); },
	          wipeRight: function() { jQuery("#myCarousel").carousel('prev'); },
	          min_move_x: 20,
	          preventDefaultEvents: true
		});

	};

});