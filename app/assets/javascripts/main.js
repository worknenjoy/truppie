$(function(){
	
	
	$('#carousel-intro').carousel({interval: false});
	
	$(document).ready(function(){
	 	$('#carousel-intro').on('swiperight', function(){
	 		$(this).carousel('prev');
	 	}).on('carousel-intro', function(){
	 		$(this).carousel('next');
	 	});
	});
	
	
});
