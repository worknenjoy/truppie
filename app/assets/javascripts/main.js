function is_touch_device() {
 return (('ontouchstart' in window)
      || (navigator.MaxTouchPoints > 0)
      || (navigator.msMaxTouchPoints > 0));
}

function is_desktop_screen() {
	return window.innerWidth > 480;
}

var timeoutID;

function delayedAlert() {
  timeoutID = window.setTimeout(slowAlert, 12000);
}

function slowAlert() {
  $('.overall-alert').removeClass('slideInDown').addClass('fadeOutUp');
}

function clearAlert() {
  window.clearTimeout(timeoutID);
}

$(function(){
	
	$('.dropdown-toggle').dropdown();
	
	$('form').on('submit', function(){
		$(this).find('input[type=submit]').attr('disabled', '');
	});
	
	localStorage.clear();
	
	$('#tour_included, #tour_nonincluded, #tour_take, #tour_goodtoknow, .package-value').tagsinput({
		delimiter: ";"
	});
	
	$('#add-packages').on('click', function(){
		$('.packages-set').clone().insertBefore(this);
		return false;
	});
	
	$('.activate-tooltip').tooltip();
	
	var where = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  prefetch: {
	    url: '/wheres/index.json',
	    filter: function(list) {
	      return $.map(list, function(where) {
	        return where; 
    	  });
	    }
	  }
	});
	where.initialize();
	
	$('#tour_where').tagsinput({
	  typeaheadjs: {
	    name: 'where',
	    displayKey: 'name',
	    valueKey: 'name',
	    source: where.ttAdapter()
	  },
	  delimiter: ';',
	  maxTags: 1
	});
	
	var tags = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  prefetch: {
	    url: '/tags/index.json',
	    filter: function(list) {
	      return $.map(list, function(tag) {
	        return tag; 
    	  });
	    }
	  }
	});
	tags.initialize();
	
	$('#tour_tags').tagsinput({
	  typeaheadjs: {
	    name: 'tags',
	    displayKey: 'name',
	    valueKey: 'name',
	    source: tags.ttAdapter()
	  },
	  delimiter: ';'
	});
	
	var languages = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  prefetch: {
	    url: '/languages/index.json',
	    filter: function(list) {
	      return $.map(list, function(languages) {
	        return languages; 
    	  });
	    }
	  }
	});
	languages.initialize();
	
	$('#tour_languages').tagsinput({
	  typeaheadjs: {
	    name: 'languages',
	    displayKey: 'name',
	    valueKey: 'name',
	    source: languages.ttAdapter()
	  },
	  delimiter: ';'
	});
	
	var organizers = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  prefetch: {
	    url: '/organizers.json',
	    filter: function(list) {
	      return $.map(list, function(organizers) {
	        return organizers; 
    	  });
	    }
	  }
	});
	organizers.initialize();
	
	$('#tour_organizer').tagsinput({
	  typeaheadjs: {
	    name: 'organizers',
	    displayKey: 'name',
	    valueKey: 'name',
	    source: organizers.ttAdapter()
	  },
	  delimiter: ';',
	  maxTags: 1
	});
	
	$('#reveal-new-cat').on('click', function(){
  		$('#new-cat').show();
  		return false;
  	});
	
	$(".criar-truppie").on('click', function(){
		
		if($('#new-cat').find('input').val().length) {
			var option = new Option($('#new-cat').find('input').val(), $('#new-cat').find('input').val());
			$('#tour_category_id').append($(option).attr('selected', 'selected'));
			$('#tour_category_id').trigger('change');
		}
		
		$('#new_tour, .edit_tour').trigger('submit');
		return false;
	});
	
	$(".criar-guia").on('click', function(){
		console.log(' bla');
		$('#new_organizer, .edit_organizer').trigger('submit');
		return false;
	});
	
	
	$('#carousel-intro').carousel();
	
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
 	
 	if(is_touch_device() && !is_desktop_screen()) {
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
	
	$('a[href="#navbar-more-show"], .navbar-more-overlay').on('click', function(event) {
		event.preventDefault();
		$('body').toggleClass('navbar-more-show');
		if ($('body').hasClass('navbar-more-show'))	{
			$('a[href="#navbar-more-show"]').closest('li').addClass('active');
		}else{
			$('a[href="#navbar-more-show"]').closest('li').removeClass('active');
		}
		return false;
	});
	
	$("#confirm-reservation").click(function() {
	    var cc = new Moip.CreditCard({
	      number  : $("#number").val(),
	      cvc     : $("#cvc").val(),
	      expMonth: $("#expiration_month").val(),
	      expYear : $("#expiration_year").val(),
	      pubKey  : $("#public_key").val()
	    });
	    if( cc.isValid()){
	      $("#hash").val(cc.hash());
	    } else {
	      $("#hash").val('');
	      $('.form-card-number .alert').remove();
	      $('.form-card-number').prepend('<div class="alert alert-danger animated bounceIn"><strong>Cartão de crédito inválido</strong><br />Verifique: número, código de confirmação, mês de expiração, ano de expiração</div>');
	      return false; // Don't submit the form
	    }
	  });
	  
  	if($('.overall-alert').length) {
  		delayedAlert();
  		$('.close').on('click', function () {
  			$('.overall-alert').removeClass('slideInDown').addClass('fadeOutUp');
		});
  	}
  	
 	new WOW().init();
 	
 	if($('.cc-package-options').length) {
 	  $('.cc-final-price span').text($('.cc-package-options').find(":checked").val());
 	  $('#cc-final-price').val($('.cc-package-options').find(":checked").val());
 	}
 	
 	if($('.b-package-options').length) {
    $('.b-final-price span').text($('.b-package-options').find(":checked").val());
    $('#b-final-price').val($('.b-package-options').find(":checked").val());
  }  
 	
 	$('.cc-amount-output').bootstrapNumber({
    upClass: 'cc-plus',
    downClass: 'cc-minus',
    resultClass: 'cc-final-price span',
    inputId: 'cc-final-price',
    changeEl: 'cc-package-options',
    center: true
  });
  
  $('.b-amount-output').bootstrapNumber({
    upClass: 'b-plus',
    downClass: 'b-minus',
    resultClass: 'b-final-price span',
    inputId: 'b-final-price',
    changeEl: 'b-package-options',
    center: true
  });
  
  $('.payments .button').bind('click', function(){
    $('.payments .button').removeClass('active');
    $(this).addClass('active');
    var tgt = $(this).attr('data-target');
    var tohide = $(".payment-tab").hide();
    $(tgt).show();
    return false;
  });
 	 	
});
