(function($) {

  $('*[data-timepicker]').attr('autocomplete','off').keydown(function(e){

    // Input Value var
    var inputValue = $(this).val();

    // Make sure keypress value is a Number
    if( (e.keyCode > 47 && e.keyCode < 58) || e.keyCode == 8){

      // Make sure first value is not greater than 2
      if(inputValue.length == 0){
        if(e.keyCode > 49){
          e.preventDefault();
          $(this).val(2);
        }
      }

      // Make sure second value is not greater than 4
      else if(inputValue.length == 1 && e.keyCode != 8){
        e.preventDefault();
        if( e.keyCode > 50 ){
          $(this).val(inputValue + '3:');
        }
        else{
          $(this).val(inputValue + String.fromCharCode(e.keyCode) + ':');
        }
      }

      else if(inputValue.length == 2 && e.keyCode != 8){
        e.preventDefault();
        if( e.keyCode > 52 ){
          $(this).val(inputValue + ':5');
        }
        else{
          $(this).val(inputValue + ':' + String.fromCharCode(e.keyCode));
        }
      }

      // Make sure that third value is not greater than 5
      else if(inputValue.length == 3 && e.keyCode != 8){
        if( e.keyCode > 52 ){
          e.preventDefault();
          $(this).val( inputValue + '5' );
        }
      }

      // Make sure only 5 Characters can be input
      else if(inputValue.length > 4 && e.keyCode != 8){
        e.preventDefault();
        return false;
      }
    }

    // Prevent Alpha and Special Character inputs
    else{
      e.preventDefault();
      return false;
    }
  }); // End Timepicker KeyUp function

})(jQuery);
