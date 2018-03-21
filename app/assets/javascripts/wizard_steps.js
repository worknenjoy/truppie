function wizzardSteps(selector){
  var wizzard_trigger_elem = $(selector)
  if(wizzard_trigger_elem.length){
    showText = wizzard_trigger_elem.data('showText');
    hideText = wizzard_trigger_elem.data('hideText');
    wizzardTargetElem = $('#' + wizzard_trigger_elem.data('target'));
    wizzard_trigger_elem.on('click', function(event){
      if(wizzardTargetElem.is(':visible')){
        wizzard_trigger_elem.html(showText);
      }else{
        wizzard_trigger_elem.html(hideText);
      }
      wizzardTargetElem.toggle('medium');
    })
  }
};

wizzardSteps('#wizard-steps-toggle');
