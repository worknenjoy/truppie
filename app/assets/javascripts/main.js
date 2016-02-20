$(function(){
	
	
	$('#carousel-intro').carousel({interval: false});
	
 	$('#carousel-intro').on('swiperight', function(e){
 		console.info(e.target);
		$('#carousel-intro').carousel('prev');
 	}).on('swipeleft', function(){
		$('#carousel-intro').carousel('next');
 	});
	
	
});
