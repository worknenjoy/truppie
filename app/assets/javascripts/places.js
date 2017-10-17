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

            if (places.length == 0) {
                return;
            }

            var name_field = $('#background_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            var lat_field = $('#background_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            var long_field = $('#background_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            var city_field = $('#background_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            var state_field = $('#background_wheres_attributes_0_state');
            if(state_field) {
                var state_field_component = places[0].address_components[1];
                if(state_field_component) {
                    state_field.val(state_field_component.short_name);
                } else {
                    state_field.val("");
                }
            }

            var country_field = $('#background_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            var postal_code_field = $('#background_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            var address_field = $('#background_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            var url_field = $('#background_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            var google_id_field = $('#background_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            var place_id_field = $('#background_wheres_attributes_0_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }

            var name_field = $('#background_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            var lat_field = $('#background_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            var long_field = $('#background_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            var city_field = $('#background_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            var state_field = $('#background_wheres_attributes_0_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            var country_field = $('#background_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            var postal_code_field = $('#background_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            var address_field = $('#background_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            var url_field = $('#background_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            var google_id_field = $('#background_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            var place_id_field = $('#background_wheres_attributes_0_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }

            // organizer signup
            name_field = $('#organizer_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            lat_field = $('#organizer_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            long_field = $('#organizer_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            city_field = $('#organizer_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            state_field = $('#organizer_wheres_attributes_0_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            country_field = $('#organizer_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            postal_code_field = $('#organizer_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            address_field = $('#organizer_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            url_field = $('#organizer_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            google_id_field = $('#organizer_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            place_id_field = $('#organizer_wheres_attributes_0_place_id');
            if(place_id_field) {
                place_id_field.val(places[0].place_id);
            }

            // background

            var name_field = $('#background_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            var lat_field = $('#background_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            var long_field = $('#background_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            var city_field = $('#background_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            var state_field = $('#background_wheres_attributes_0_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            var country_field = $('#background_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            var postal_code_field = $('#background_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            var address_field = $('#background_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            var url_field = $('#background_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            var google_id_field = $('#background_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            var place_id_field = $('#background_wheres_attributes_0_place_id');
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


            // for guidebook signup

            name_field = $('#guidebook_wheres_attributes_0_name');
            if(name_field) {
                name_field.val(places[0].name);
            }

            lat_field = $('#guidebook_wheres_attributes_0_lat');
            if(lat_field) {
                lat_field.val(places[0].geometry.location.lat());
            }

            long_field = $('#guidebook_wheres_attributes_0_long');
            if(long_field) {
                long_field.val(places[0].geometry.location.lng());
            }

            city_field = $('#guidebook_wheres_attributes_0_city');
            if(city_field) {
                city_field.val(places[0].address_components[0].short_name);
            }

            state_field = $('#guidebook_wheres_attributes_0_state');
            if(state_field) {
                state_field.val(places[0].address_components[1].short_name);
            }

            country_field = $('#guidebook_wheres_attributes_0_country');
            if(country_field) {
                country_field.val(places[0].address_components[2].short_name);
            }

            postal_code_field = $('#guidebook_wheres_attributes_0_postal_code');
            if(postal_code_field) {
                postal_code_field.val(places[0].address_components[3].short_name);
            }

            address_field = $('#guidebook_wheres_attributes_0_address');
            if(address_field) {
                address_field.val(places[0].formatted_address);
            }

            url_field = $('#guidebook_wheres_attributes_0_url');
            if(url_field) {
                url_field.val(places[0].url);
            }

            google_id_field = $('#guidebook_wheres_attributes_0_google_id');
            if(google_id_field) {
                google_id_field.val(places[0].id);
            }

            place_id_field = $('#guidebook_wheres_attributes_0_place_id');
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

  function initMap() {
    var map = new google.maps.Map(document.getElementById("map_canvas"), {
      zoom      : 10,
      map       : map,
      mapTypeId : google.maps.MapTypeId.ROADMAP,
      disableDefaultUI : false,
      center: {lat: -22.928749, lng: -43.1973497}
    })

    $.ajax({
      url: '/tours',
      type: 'GET',
      dataType: 'json',
      success: function(data){
        console.log("Success");
        console.log(data);
        for (var i = 0; i < data.length; i++) {
          place_marker(map, data[i]);
        }
        
      },
      error: function(xhr, status, response) {
        console.log(response);
      } 
    })    
  }

  function place_marker(map, tour){
    var mapMarkerAwesome = mapMarkerAwesomeFactory(true);
    var geocoder = new google.maps.Geocoder;
    var placeId = tour.where.place_id;
    var tourLat = parseFloat(tour.where.lat);
    var tourLng = parseFloat(tour.where.long);
    var mapIcon = {
      url: mapMarkerAwesome('fa-ticket'),
      origin: new google.maps.Point(0, 0)
    }


    if (!!placeId){
      var place_object = {placeId: placeId };
    } else if (!!tourLat && !!tourLng) {
      var place_object = {location: {lat: tourLat, lng: tourLng}};
    } else {
      var place_object = null;
    }

    if (!!place_object){
      var info_content = "<div class='googft-info-window' style='width: 400px; height: 13em; overflow-y: auto;'>" +
        "<div class='row' style='margin-left: 0rem; margin-right: 0rem;'>" +
        "<div class='col-md-4'>" +
        "<img src='" + tour.thumbnail + "' style='width: 100px; vertical-align: top; margin-right: .5em' />" + 
        "</div>" +
        "<div class='col-md-8'>" +
        "<h5 style='color: #c1390d'>" + tour.price + "</h5>" + 
        "<p>" + tour.address + "</p>" +
        "<p>" + rating_stars(tour.rating) + "</p>" +
        "</div>" +
        "</div>" +
        "<div class='row' style='margin-left: 0rem; margin-right: 0rem;'>" +
        "<div class='col-md-8'>" +
        "<p><strong>" + tour.title + "</strong></p>" +
        "</div>" +
        "<div class='col-md-4'>" +
        "<a href='" + tour.url + "' class='pull-right btn btn-primary'>Tour</a>" +
        "</div>" +
        "</div>" +
        "</div>";
      geocoder.geocode(place_object, function (results, status) {
        if (status === 'OK') {
            if (results[0]) {
                map.setZoom(11);
                map.setCenter(results[0].geometry.location);
                var marker = new google.maps.Marker({
                    map: map,
                    icon: mapIcon,
                    position: results[0].geometry.location
                });
                var infowindow = new google.maps.InfoWindow({ content : info_content });

                marker.addListener('click', function() { 
                  infowindow.open(map, marker);
                })
            }
        } else {
            window.alert('Geocoder failed due to: ' + status);
        }
      });
    }

  }

  function rating_stars(rating){
    var tempRating = rating;
    var ratingStarsString = "";
    var ratingDiff = 5 - tempRating;
    while (tempRating > 0){
      ratingStarsString += "<span class='fa fa-star checked'></span>";
      tempRating--;
    }

    for (var i = 0; i < ratingDiff; i++) {
      ratingStarsString += "<span class='fa fa-star'></span>";   
    }

    return ratingStarsString;
  }

  initMap();
})();