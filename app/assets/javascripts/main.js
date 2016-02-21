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
 	
 	if(window.DocumentTouch && document instanceof DocumentTouch) {
 		$('.carousel-navigation').hide();
 	}
	
	
});
