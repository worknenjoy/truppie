$(function () {

    // Global Variables //

    var ulList = $('.ulList'),
        ulImg  = $('.ulList .ulImg'),
        ulTxt  = $('.ulList .ulTxt'),
        liList = $('.liList'),
        liDiv  = $('.liList .li'),
        liImg  = $('.liList .li img');

    // Hide Li List When Toggle UL List And Click Away It //

    ulList.on('click', function (e) {
        liList.toggle();
        e.stopPropagation(); // stope Li List Toggle Event For Run The Dom Event (Click Away Li List)
        $(document).on('click', function () { // Function To Hide Li List When Click Any Place in Dom
            liList.hide();
        });
        return false;
    });


    // Put Li List Img And Text In Ul List //

    liDiv.on('click', selectingCountry);

    function selectingCountry() {
        //ulImg.attr('src', $(this).children('img').attr('src')).show();
        //ulTxt.text($(this).text());
        //return false;
    }
});