function extractFromAdress(components, type){
    for (var i=0; i<components.length; i++)
        for (var j=0; j<components[i].types.length; j++)
            if (components[i].types[j]==type) return components[i].short_name;
    return "";
}

function set_places_info(target, places) {
    if (places.length == 0) {
        return;
    }

    var name_field = $('#' + target + '_wheres_attributes_0_name');
    if(name_field && places[0].hasOwnProperty('name')) {
        name_field.val(places[0].name);
    }

    var lat_field = $('#' + target + '_wheres_attributes_0_lat');
    if(lat_field && places[0].hasOwnProperty('geometry')) {
        lat_field.val(places[0].geometry.location.lat());
    }

    var long_field = $('#' + target + '_wheres_attributes_0_long');
    if(long_field) {
        long_field.val(places[0].geometry.location.lng());
    }

    var address_components = places[0].address_components;

    var city_field = $('#' + target + '_wheres_attributes_0_city');
    if(city_field) {
        city_field.val(extractFromAdress(address_components, "locality"));
    }

    var state_field = $('#' + target + '_wheres_attributes_0_state');
    if(state_field) {
        state_field.val(extractFromAdress(address_components, "administrative_area_level_2"));
    }

    var country_field = $('#' + target + '_wheres_attributes_0_country');
    if(country_field) {
        country_field.val(extractFromAdress(address_components, "country"));
    }

    var postal_code_field = $('#' + target + '_wheres_attributes_0_postal_code');
    if(postal_code_field) {
        postal_code_field.val(extractFromAdress(address_components, "postal_code"));
    }

    var address_field = $('#' + target + '_wheres_attributes_0_address');
    if(address_field) {
        address_field.val(extractFromAdress(address_components, "street"));
    }

    var url_field = $('#' + target + '_wheres_attributes_0_url');
    if(url_field) {
        url_field.val(places[0].url);
    }

    var google_id_field = $('#' + target + '_wheres_attributes_0_google_id');
    if(google_id_field) {
        google_id_field.val(places[0].id);
    }

    var place_id_field = $('#' + target + '_wheres_attributes_0_place_id');
    if(place_id_field) {
        place_id_field.val(places[0].place_id);
    }
}

(function() {
    "use strict";

    var input = document.querySelector(".places-input");
    if(input) {
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

        input.addEventListener('focus', function () {
            mapdiv.style.display = 'block';
            var center = map.getCenter();
            google.maps.event.trigger(map, "resize");
            map.setCenter(center);
        }, true);

        /*input.addEventListener('blur', function(){
         mapdiv.style.display = 'none';
         }, true);
         */

        map.addListener('bounds_changed', function () {
            searchBox.setBounds(map.getBounds());
        });

        var current_place_name = document.getElementById('tour_wheres_attributes_0_name');

        if(current_place_name) {
            var current_place = document.getElementById('tour_wheres_attributes_0_name').value;
            if(current_place) {
                input.value = current_place;
            }
        }

        searchBox.addListener("places_changed", function (e) {
            var places = searchBox.getPlaces();
            //console.log('places');
            //console.log(places);
            //console.log(places[0].geometry.location)

            set_places_info('background', places);
            set_places_info('organizer', places);
            set_places_info('tour', places);
            set_places_info('guidebook', places);


            // Clear out the old markers.
            markers.forEach(function (marker) {
                marker.setMap(null);
            });
            markers = [];

            var bounds = new google.maps.LatLngBounds();
            places.forEach(function (place) {
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

        if (resetBtn) {

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

        google.maps.event.addDomListener(window, "resize", function () {
            var center = map.getCenter();
            google.maps.event.trigger(map, "resize");
            map.setCenter(center);
        });
    }
})();