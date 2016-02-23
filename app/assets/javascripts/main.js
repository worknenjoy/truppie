function is_touch_device() {
 return (('ontouchstart' in window)
      || (navigator.MaxTouchPoints > 0)
      || (navigator.msMaxTouchPoints > 0));
}

$(function(){
	
	
	$('#carousel-intro').carousel({interval: false});
	
 	$('#carousel-intro').on('swiperight', function(e){
		$('#carousel-intro').carousel('prev');
 	}).on('swipeleft', function(){
		$('#carousel-intro').carousel('next');
 	});
 	
 	$('.carousel-right').on('click',function(){
 		$('#carousel-intro').carousel('next');
 		return false;
 	});
 	
 	$('.carousel-left').on('click',function(){
 		$('#carousel-intro').carousel('prev');
 		return false;
 	});
 	
 	if(is_touch_device()) {
 		$('.carousel-navigation').hide();
 	}
 	
 	$('#carousel-intro')
		.on('movestart', function(e) {
		  // If the movestart is heading off in an upwards or downwards
		  // direction, prevent it so that the browser scrolls normally.
		  if ((e.distX > e.distY && e.distX < -e.distY) ||
		      (e.distX < e.distY && e.distX > -e.distY)) {
		    e.preventDefault();
		  }
		});
 	
 	new WOW().init();
	
	
});
