
console.clear();

'use strict';


/* --------------------------------
 Icon component
 https://codepen.io/afalchi82/pen/XegMom
 ---------------------------------*/
Vue.component('vue-icon', {
    template: `
    <svg version="1.1" style="vertical-align: middle;" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" :width="size" x="0px" y="0px" viewBox="0 0 18 18" xml:space="preserve">
      <g v-if="symbol === 'x'">
        <g>
          <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="15.4" y1="2.6" x2="9" y2="9"/>
          <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="15.4" y1="15.4" x2="9" y2="9"/>
        </g>
        <g>
          <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="2.6" y1="2.6" x2="9" y2="9"/>
          <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="2.6" y1="15.4" x2="9" y2="9"/>
        </g>
      </g>
      <g v-if="symbol === 'next'">
        <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="5.8" y1="2.6" x2="12.2" y2="9"/>
        <line :style="'fill:none; stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="5.8" y1="15.4" x2="12.2" y2="9"/>
      </g>
      <g v-if="symbol === 'prev'">
        <line :style="'fill:none;stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="12.2" y1="2.6" x2="5.8" y2="9"/>
        <line :style="'fill:none;stroke:' + color + ';stroke-width:2;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;'" x1="12.2" y1="15.4" x2="5.8" y2="9"/>
      </g>
    </svg>`,
    props: {
        color: {
            type: String,
            default: 'white'
        },
        symbol: {
            type: String,
            required: true
        },
        size: {
            type: String,
            default: '18'
        }
    }
});



// Person Class used inside component
var Person = function() {
    this.name = { first: '',  last: '' };
    this.picture = { large: '', thumb: '' };
    this.id = { value: '' };
    this.type = '';
};


/* --------------------------------
 Facemosaic component
 ---------------------------------*/
var facemosaic = new Vue({

    el: '.facemosaic',


    data: {
        detailVisible: false,
        mosaic: {
            cols: 3,
            hasSomeBig: false,
            hasSomeEmpty: false,
            isHover: false,
            numpeople: 32
        },
        people: [],
        selectedPerson: new Person(),
        slide: {
            auto: true,
            counter: 0,
            delay: 3000,
            isPaused: false,
            rowsToSlide: 1
        },

        tileSize: 0 // Valorizzata all'evento mounted
    },


    components: {
        facemosaicDetail: {},
        facemosaicPerson: {
            template: `
        <div class="facemosaic__person" :class="{'empty': person.type === 'empty'}" :style="'width:' + tileSize * person.size + 'px; height:' + tileSize * person.size + 'px'"> 
        <a href="" 
        v-if="person.type !== 'empty'" 
        :title="person.name.first + ' ' + person.name.last" 
        @click.prevent="clickHandler" 
        @touchstart="stopAutoplay"> 
        <div class="cta">{{ cta }}</div>
        <img :src="person.picture.large" alt=""> 
        </a>
        </div>`,
            props: ['people', 'person', 'index', 'stopAutoplay', 'startAutoplay', 'tileSize', 'cta'],
            methods: {
                clickHandler: function () {
                    this.$emit('opendetail', this.person);
                }
            }
        }
    },

    filters: {
        capitalize: function (string) {
            if (string) {
                return string[0].toUpperCase() + string.slice(1);
            }
        }
    },


    methods: {
        animateScrollWrapper: function () {
            var vm = this;
            var wrapper = this.$el.querySelector('.facemosaic__wrapper');
            var scroller = this.$el.querySelector('.facemosaic__scroller');

            function animate() {
                $(wrapper).animate({scrollTop: vm.tileSize * vm.slide.rowsToSlide * vm.slide.counter}, 800);
            }

            var interval = setInterval(function () {
                var scrollCondition = scroller.clientHeight > (wrapper.clientHeight + wrapper.scrollTop);
                if (scrollCondition && !vm.slide.isPaused && !vm.detailVisible) {
                    animate();
                    vm.slide.counter += 1;
                } else if (!scrollCondition && !vm.slide.isPaused && !vm.detailVisible) {
                    animate();
                    vm.slide.counter = 0;
                }

            }, vm.slide.delay);
        },

        loadProfiles: function () {
            var vm = this;

            // Aggiunge proprietà "size"
            function addPeopleSize () {
                vm.people.map(function (item) {
                    return item.size = 1;
                });
            }

            // Rende più grandi alcuni profili a caso
            function makeSomeBig () {
                vm.people.map(function (item) {
                    var rndm = Math.round(Math.random()*2);
                    if (rndm === 0) {
                        return item.size = 1;
                    } else {
                        return item.size = 2;
                    }
                });
            }

            // Aggiunge dei blocchi vuoti
            function makeSomeEmpty () {
                var emptyTile = new Person();
                emptyTile.type = 'empty';
                emptyTile.size = 1;

                vm.people.forEach(function (item, index) {
                    var rndm = Math.round(Math.random()*4);
                    if (rndm === 0) {
                        vm.people.splice(index+1, 0, emptyTile);
                    }
                });
            }

            var people = $.get('https://randomuser.me/api/?inc=name,picture&results=' + this.mosaic.numpeople + '&inc=id,location,nat,name,picture,age')
                .done(function (response) {
                    vm.people = response.results;
                    addPeopleSize();
                    vm.mosaic.hasSomeBig ? makeSomeBig() : null;
                    vm.mosaic.hasSomeEmpty ? makeSomeEmpty() : null;
                })
                .fail(function() {
                    console.log('Error loading data!');
                })
            ;
        },

        setSelectedPerson: function (ev) {
            this.detailVisible = true;
            this.selectedPerson = ev;
            this.slide.isPaused = true;
        },
        stopAutoplay: function () { this.slide.isPaused = true; },
        startAutoplay: function () {this.slide.isPaused = false; },
        resizeHandler: function () {
            this.tileSize = Math.floor(this.$el.clientWidth / this.mosaic.cols);
            this.slide.counter = 0;
        }
    },


    mounted: function () {
        var vm = this;
        vm.loadProfiles();

        vm.$nextTick(function() {
            window.addEventListener('resize', _.debounce(vm.resizeHandler, 300));

            // Updates scroll counter after user scroll
            vm.$el.querySelector('.facemosaic__wrapper').addEventListener('scroll', function () {
                if ( vm.slide.isPaused ) {
                    vm.slide.counter = Math.ceil(this.scrollTop / vm.tileSize);
                }
            });

            // Init
            this.resizeHandler();
        });
        if (vm.slide.auto) { vm.animateScrollWrapper();}
    }


});




