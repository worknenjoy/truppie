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

        searchBox.addListener("places_changed", function (e) {
            var places = searchBox.getPlaces();
            console.log('places');
            console.log(places);
            console.log(places[0].geometry.location)

            if (places.length == 0) {
                return;
            }

            var name_field = $('#background_wheres_attributes_0_name') || $('#tour_where_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            var lat_field = $('#background_wheres_attributes_0_lat') || $('#tour_where_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            var long_field = $('#background_wheres_attributes_0_long') || $('#tour_where_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            var city_field = $('#background_wheres_attributes_0_city') || $('#tour_where_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            var state_field = $('#background_wheres_attributes_0_state') || $('#tour_where_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            var country_field = $('#background_wheres_attributes_0_country') || $('#tour_where_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            var postal_code_field = $('#background_wheres_attributes_0_postal_code') || $('#tour_where_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            var address_field = $('#background_wheres_attributes_0_address') || $('#tour_where_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            var url_field = $('#background_wheres_attributes_0_url') || $('#tour_where_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            var google_id_field = $('#background_wheres_attributes_0_google_id') || $('#tour_where_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            var place_id_field = $('#background_wheres_attributes_0_place_id') || $('#tour_where_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }

            var name_field = $('#background_wheres_attributes_0_name') || $('#tour_where_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            var lat_field = $('#background_wheres_attributes_0_lat') || $('#tour_where_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            var long_field = $('#background_wheres_attributes_0_long') || $('#tour_where_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            var city_field = $('#background_wheres_attributes_0_city') || $('#tour_where_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            var state_field = $('#background_wheres_attributes_0_state') || $('#tour_where_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            var country_field = $('#background_wheres_attributes_0_country') || $('#tour_where_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            var postal_code_field = $('#background_wheres_attributes_0_postal_code') || $('#tour_where_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            var address_field = $('#background_wheres_attributes_0_address') || $('#tour_where_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            var url_field = $('#background_wheres_attributes_0_url') || $('#tour_where_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            var google_id_field = $('#background_wheres_attributes_0_google_id') || $('#tour_where_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            var place_id_field = $('#background_wheres_attributes_0_place_id') || $('#tour_where_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }


            // for tour signup

            name_field = $('#tour_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            lat_field = $('#tour_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            long_field = $('#tour_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            city_field = $('#tour_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            state_field = $('#tour_wheres_attributes_0_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            country_field = $('#tour_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            postal_code_field = $('#tour_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            address_field = $('#tour_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            url_field = $('#tour_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            google_id_field = $('#tour_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            place_id_field = $('#tour_wheres_attributes_0_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }



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

    var places_image_secondary = document.querySelectorAll('.places-image-secondary')[0];

    if(places_image_secondary) {

    }



})();