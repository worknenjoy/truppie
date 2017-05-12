(function() {
    "use strict";

    var input = document.querySelector(".places-input");
    var mapdiv = document.getElementById('map');
    var map = new google.maps.Map(mapdiv, {
        center: {
            lat: -14.235004,
            lng: -51.92528
        },
        zoom: 3,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    var markers = [];
    var resetBtn = document.querySelector(".btn-reset");
    var searchBox = new google.maps.places.SearchBox(input);

    mapdiv.style.display = 'none';

    input.addEventListener('focus', function(){
        mapdiv.style.display = 'block';
        var center = map.getCenter();
        google.maps.event.trigger(map, "resize");
        map.setCenter(center);
    }, true);

    /*input.addEventListener('blur', function(){
        mapdiv.style.display = 'none';
    }, true);
    */

    map.addListener('bounds_changed', function() {
        searchBox.setBounds(map.getBounds());
    });

    searchBox.addListener("places_changed", function(e) {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // Clear out the old markers.
        markers.forEach(function(marker) {
            marker.setMap(null);
        });
        markers = [];

        var bounds = new google.maps.LatLngBounds();
        places.forEach(function(place) {
            var icon = {
                url: place.icon,
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(25, 25)
            };

            // Create a marker for each place.
            markers.push(
                new google.maps.Marker({
                    map: map,
                    icon: icon,
                    title: place.name,
                    position: place.geometry.location
                })
            );

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });

        map.fitBounds(bounds);
    });

    if(resetBtn) {

        resetBtn.addEventListener("click", function (e) {
            markers.forEach(function (marker) {
                marker.setMap(null);
            });
            markers = [];

            map = new google.maps.Map(document.getElementById('map'), {
                center: {
                    lat: -13.4930348,
                    lng: -69.8504647
                },
                zoom: 3,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

            input.value = "";
        }, false);
    }

    google.maps.event.addDomListener(window, "resize", function() {
        var center = map.getCenter();
        google.maps.event.trigger(map, "resize");
        map.setCenter(center);
    });
})();