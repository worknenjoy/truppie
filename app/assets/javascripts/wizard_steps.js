$(document).ready(function() {
  trigger_elem = $('#wizard-steps-toggle');
  if(trigger_elem.length){
    showText = trigger_elem.data('showText');
    hideText = trigger_elem.data('hideText');
    targetElem = $('#' + trigger_elem.data('target'));
    trigger_elem.on('click', function(event){
      if(targetElem.is(':visible')){
        trigger_elem.html(showText);
      }else{
        trigger_elem.html(hideText);
      }
      targetElem.toggle('medium');
    })
  }
});
