$(document).ready(function() {
  $('.step').each(function(index, el) {
    elem = $(el);
    elem.not('.active').addClass('done').html('<i class="fa fa-check"></i>');
    if($(this).is('.active')) {
      return false;
    }
  });
});
