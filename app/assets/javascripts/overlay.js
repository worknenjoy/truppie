(function() {
  var triggerBttn = document.getElementById( 'js-trigger-overlay' ),
        overlay = document.querySelector( 'div.overlay' ),
        body = document.querySelector( 'body' );
        var transEndEventNames = {
      'WebkitTransition': 'webkitTransitionEnd',
                        'MozTransition': 'transitionend',
                        'OTransition': 'oTransitionEnd',
                        'msTransition': 'MSTransitionEnd',
                        'transition': 'transitionend'
    },
    transEndEventName = transEndEventNames[ Modernizr.prefixed( 'transition' ) ],
    support = { transitions : Modernizr.csstransitions };
    if(overlay) {
      var closeBttn = overlay.querySelector( 'button.close' );
    }

  function toggleOverlay() {
      if( classie.has( overlay, 'open' ) ) {
          classie.remove( overlay, 'open' );
          classie.add( overlay, 'close' );
          classie.remove(body, 'no-scroll');
          var onEndTransitionFn = function( ev ) {
              if( support.transitions ) {
                  if( ev.propertyName !== 'visibility' ) return;
                  this.removeEventListener( transEndEventName, onEndTransitionFn );
              }
            classie.remove( overlay, 'close' );
          }
          if( support.transitions ) {
              overlay.addEventListener( transEndEventName, onEndTransitionFn );
          }
      else {
        onEndTransitionFn();
      }
    }
    else if( !classie.has( overlay, 'close' ) ) {
      classie.add( overlay, 'open' );
      classie.add( body, 'no-scroll' );
    }
  }
  if(triggerBttn && closeBttn) {
    triggerBttn.addEventListener( 'click', toggleOverlay );
    closeBttn.addEventListener( 'click', toggleOverlay );
  }
})();