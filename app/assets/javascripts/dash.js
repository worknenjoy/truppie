    // add our class to the action menu to set the styles if javascript is enabled
    $('.dash-item__nav').each(function() {

        $(this).addClass('dash-item__nav--collapsible')
            .attr('aria-hidden', true)
            .before('<button class="dash-item__menu-action" type="button" aria-expanded="false" aria-controls="'+$(this).attr('id')+'"><svg class="dash-item__menu-action__icon dash-item__menu-action__icon--bottom"><use xlink:href="#icon-chevron" /></svg><svg class="dash-item__menu-action__icon dash-item__menu-action__icon--top"><use xlink:href="#icon-chevron" /></svg></button>');
    });

    var called = false;
    $(document).on('click', '.dash-item__menu-action', function() {
      if(called){ return; }

        var dashItem = $(this).closest('.dash-item');

        if(dashItem.hasClass('dash-item--menu-active')) {
            // remove states from the active menu item
            removeActiveMenuStates(dashItem);
            $('body').removeClass('dash-list--focus-one');

        } else {
            // remove states from any active menu item, if there is one
            var previouslyActiveMenu = $('.dash-item--menu-active');
            if(0 < previouslyActiveMenu.length ) {
                removeActiveMenuStates(previouslyActiveMenu);
            }

            // add in the active states to the clicked dashItem
            addActiveMenuStates(dashItem);

            // add a class to the body telling that there's a dashItem active
            $('body').addClass('dash-list--focus-one');

            // move focus to first item in newly opened menu
            $('.dash-item__nav__item:eq(0) a', dashItem).focus();
        }
        called = true;
        setTimeout(function(){called = false;}, 300);
    });

    function addActiveMenuStates(dashItem) {
        // add the new active states in
        dashItem.addClass('dash-item--menu-active');
        // button to activate the menu
        $('.dash-item__menu-action', dashItem).attr('aria-expanded', true);
        // menu
        $('.dash-item__nav', dashItem).attr('aria-hidden', false);
    }

    function removeActiveMenuStates(dashItem) {
        // dash item card
        dashItem.removeClass('dash-item--menu-active');
        // button to activate the menu
        $('.dash-item__menu-action', dashItem).attr('aria-expanded', false)
        // menu
        $('.dash-item__nav', dashItem).attr('aria-hidden', true);
    }
