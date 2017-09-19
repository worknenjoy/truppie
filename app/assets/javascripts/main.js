$.fn.extend({
    animateCss: function (animationName, removeClass) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        this.addClass('animated ' + animationName).one(animationEnd, function() {
            if(removeClass){
                $(this).removeClass('animated ' + animationName);
            } else {
                $(this).remove();
            }
        });
        return this;
    }
});

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
  timeoutID = window.setTimeout(slowAlert, 5000);
}

function slowAlert() {
  $('.overall-alert').removeClass('slideInDown').addClass('fadeOutUp');
}

function clearAlert() {
  window.clearTimeout(timeoutID);
}

function eventHolder() {
    var newEventHolder = document.getElementById("newEventHolder");
    var eventForm = document.getElementById("newEventForm");
    var eventDate = document.getElementById("eventDate");
    var addEvent = document.getElementById("addEvent");
    var cancel = document.getElementById("cancelAddEvent");
    var upcomingEvents = document.getElementById("upcomingEvents");
    var eventHolder = document.getElementById("eventHolder");
    var removeEvent = document.getElementById("removeEvent");

// Show New Event form
    $(newEventHolder).on('click',function() {
        $(eventForm).slideDown(400);
        return false;
    });

// Close New Event form
    $(cancel).on('click', function() {
        $(eventForm).slideUp(400);
        return false;
    });

// Delete icon removed event from list
    $(removeEvent).on('click', function() {
        $(eventHolder).addClass('hide').stop();
        return false;
    });
}

function removeUpload() {
    $('.file-upload-input').replaceWith($('.file-upload-input').clone(true));
    $('.file-upload-content').hide();
    $('.image-upload-wrap').show();
}

function readURL(input) {
    if (input.files && input.files[0]) {

        var reader = new FileReader();
        var img = document.createElement("img");

        reader.onload = function(e) {
            $('.image-upload-wrap').hide();

            //$('.file-upload-image').attr('src', e.target.result);

            $('.file-upload-content').find('img').remove();

            img.src = e.target.result;

            img.style.width = '100%';

            $('.file-upload-content').append(img);


            $('.file-upload-content').show();

            $('.image-title').html(input.files[0].name);
        };

        reader.readAsDataURL(input.files[0]);

    } else {
        removeUpload();
    }
}

$(function() {

    $('.dropdown-toggle').dropdown();

    $('form').on('submit', function () {
        $(this).find('input[type=submit]').attr('disabled', '');
    });

    $('.close-action').on('click', function () {
        $(this).parent().animateCss('fadeOutUp', false);
        return false;
    });

    localStorage.clear();

    $('#tour_included, #tour_nonincluded, #tour_take, #organizer_policy, #tour_goodtoknow, .package-value').tagsinput({
        delimiter: ";"
    });

    $('#add-packages').on('click', function () {
        $('.packages-set').clone().insertBefore(this);
        return false;
    });

    $('.activate-tooltip').tooltip();

    if($('.where-field').length) {
        var where = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: {
                url: '/wheres/index.json',
                filter: function (list) {
                    return $.map(list, function (where) {
                        return where;
                    });
                }
            }
        });
        where.initialize();

        $('.where-field').tagsinput({
            typeaheadjs: {
                name: 'where',
                displayKey: 'name',
                valueKey: 'name',
                source: where.ttAdapter()
            },
            delimiter: ';',
            maxTags: 1
        });

    }

	var count = $('.packages-set').length;
	$('.add-packages').on('click', function(e){
	  $('<div />').load('/packages/new', function(data){
	     var new_data = $(data).find('input').each(function(e){
          $(this).attr('name', 'tour[packages_attributes][' + count  +  '][' + this.id + ']');
          console.log(this);
          if(this.id == 'included') {
            $(this).tagsinput({
              delimiter: ";"
            });
          }
        }).end();
        count++;
        $('.new-packages-content:eq(0)').prepend(new_data);
	  });
	  return false;
	});

	if($('#tour_tags').length) {

        var tags = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: {
                url: '/tags/index.json',
                filter: function (list) {
                    return $.map(list, function (tag) {
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
    }

    if($('#tour_languages').length) {

        var languages = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: {
                url: '/languages/index.json',
                filter: function (list) {
                    return $.map(list, function (languages) {
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
    }

    if($('.organizer-chooser').length) {

        var organizers = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            prefetch: {
                url: '/organizers.json',
                filter: function (list) {
                    return $.map(list, function (organizers) {
                        return organizers;
                    });
                }
            }
        });
        organizers.initialize();

        $('.organizer-chooser').tagsinput({
            typeaheadjs: {
                name: 'organizers',
                displayKey: 'name',
                valueKey: 'name',
                source: organizers.ttAdapter()
            },
            delimiter: ';',
            maxTags: 1
        });
    }

	$('#reveal-new-cat').on('click', function(){
  		$('#new-cat').show();
  		return false;
  	});

	$(".criar-truppie").on('click', function(){

		if($('#new-cat').find('input')) {
			var option = new Option($('#new-cat').find('input').val(), $('#new-cat').find('input').val());
			$('#tour_category_id').find(":selected").removeAttr("selected");
			$('#tour_category_id').append($(option).attr('selected', 'selected'));
			$('#tour_category_id').trigger('change');
		}

		$('#new_tour, .edit_tour').trigger('submit');
		return false;
	});

    $(".publish-truppie").on('click', function(){

        $('.tour-status').val('P');

        $('#new_tour, .edit_tour').trigger('submit');
        return false;
    });

	$(".criar-guia").on('click', function(){
		$('#new_organizer, .edit_organizer').trigger('submit');
		return false;
	});

	$(".create-marketplace").on('click', function(){
    $('#new_marketplace, .edit_marketplace').trigger('submit');
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

	function stripeResponseHandler(status, response) {
	  var $form = $('#form-confirm-reservation');

	  if(response.error) {
	    $form.find('.alert').remove();
	    $form.find('#confirm-reservation-button').before('<div class="dialog-alert alert alert-danger animated bounceIn"><strong>' + response.error.param + '</strong><br />' + response.error.message +  ' </div>');
	    $form.find('#confirm-reservation-button').prop('disabled', false);
	  } else {
	    $('#token').val(response.id);
      // and re-submit
      $form.get(0).submit();
	  }
	}

	$("#form-confirm-reservation").bind('submit', function() {

	    $(this).find('#confirm-reservation-button').prop('disabled', true);

	    Stripe.card.createToken($(this), stripeResponseHandler);

	   return false;
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

  $('#birthdate').mask("99/99/9999");


  //$('#start_time, #end_time').mask("Hh:Mm Pp");


  eventHolder();
    if(document.getElementById('editor-container')) {
        var quill = new Quill('#editor-container', {
            modules: {
                toolbar: [
                    [{header: [1, 2, false]}],
                    ['bold', 'italic', 'underline']
                ]
            },
            placeholder: 'descreva seu evento...',
            theme: 'snow'  // or 'bubble'
        });
        quill.container.firstChild.innerHTML = $('#tour_description').val();
        quill.on('editor-change', function(eventName, args) {
            $('#tour_description').val(quill.container.firstChild.innerHTML);
        });
    }

    $('.image-upload-wrap').on('dragover', function () {
        $('.image-upload-wrap').addClass('image-dropping');
    });
    $('.image-upload-wrap').on('dragleave', function () {
        $('.image-upload-wrap').removeClass('image-dropping');
    });

    $('.file-upload-input').on('change', function(e){
        readURL(this);
    });

    $('.clear-package').on('click', function (event) {
        $('#new-packages-modal').find('input').each(function(e){
            $(this).val('');
        });
    });

    if($('#import-from-facebook-action').length) {
        $.ajaxSetup({cache: true});
        $.getScript('//connect.facebook.net/en_US/sdk.js', function () {
            FB.init({
                appId: '1696671210617842',
                version: 'v2.5' // or v2.1, v2.2, v2.3, ...
            });
            //$('#loginbutton,#feedbutton').removeAttr('disabled');
            $('#import-from-facebook-action').on('click', function () {
                FB.login(function (response) {
                    var token = response["authResponse"]["accessToken"];
                    var user_id = response["authResponse"]["userID"];
                    var modal = $('#import-from-facebook-dialog');

                    modal.modal('show');
                    modal.on('shown.bs.modal', function () {

                        $('.loading-events').fadeIn();
                        $.getJSON('/organizers/4-7-cantos-do-mundo/external_events.json?token=' + token + '&user_id=' + user_id, function (data, status, xhr) {
                            moment.locale('pt');
                            var tmpl = $('#event-list-template');
                            var list = {event: []};
                            for (var i = 0; i < data.length; i++) {
                                list.event.push({
                                    id: data[i].id,
                                    name: data[i].name,
                                    description: data[i].description,
                                    start_time: moment(data[i].start_time).format("dddd, D MMMM YYYY, h:mm a")
                                });
                            }
                            var html = tmpl.render(list);
                            $('#imported-events-container').html(html);
                            $('#imported-events-container').addClass('animated bounceIn');
                            $('#facebook_token').val(token);
                            $('#facebook_user_id').val(user_id);
                            $('.loading-events').fadeOut();
                        }).error(function (e) {
                            console.log(e);
                            $('#imported-events-container').html('<label class="label label-warning">Não foi possível exibir os eventos</label>');
                            $('.loading-events').fadeOut();
                        });
                    });
                }, {scope: 'rsvp_event,user_events'});
                return false;
            });
        });
    }
});
