// INIT
;(function($, window, document, undefined) {
    'use strict';

    // helpers
    function _id(e) { return document.getElementById(e); }
    function _e(e) { return document.querySelector(e); }
    function _ee(e) { return document.querySelectorAll(e); }
    function _for(e,f) { var i, len=e.length; for(i=0;i<len;i++){ f(e[i]); }}
    function log(e, before) { before=before||''; console.log(before+e); }
    function _hasClass(el, selector) { var className = " " + selector + " "; if ((" " + el.className + " ").replace(/[\n\t]/g, " ").indexOf(className) > -1) { return true;  } else { return false; }}


    // user select/click action
    function userSelect(e,main,month,year){

        var sel1 = _id('sel1'),
            sel2 = _id('sel2');

        var isDisabled = _hasClass(e, 'disabled');

        // first doesnt exist
        if( sel1 === null && !isDisabled ) {
            e.id = 'sel1';
            e.classList.add('sel1');
            $(e).parent().prevAll('tr').find('td').addClass('disabled'); // ugly code
            $(e).prevAll('td').addClass('disabled'); // ugly code
            //log('select second option');

            // temp
            if( _id('out1') === null ) { $('#cal').after('<i id="out1"></i>'); }
            _id('out1').innerHTML = '<br>Selected 1: ' + e.innerText + '/' + month + '/' + year;
            _id('sel1text').innerHTML = e.innerText + '-' + month + '-' + year;
        }

        // second doesnt exist
        else if( sel2 === null ){ // prevent making #2 to #1
            if(isDisabled || e.id == 'sel1') return false;
            e.id = 'sel2';
            e.classList.add('sel2');

            // selection is complete
            var par = e.parentNode,			// tr
                parPar = par.parentNode;	// tbody (main)

            var td = parPar.querySelectorAll('td'),
                go = false,
                stop = false,
                i=0,
                s1i=0,
                s2i=999;

            _for(td, function(e){
                i++;

                if( e.id == 'sel1' ) { go=1; s1i = i; }
                if( e.id == 'sel2' ) { stop=1; s2i = i; }

                if( s1i < s2i && go ){
                    if(go){ e.classList.add('range'); }
                    // temp
                    if( _id('out2') === null ) { $('#out1').after('<i id="out2"></i>'); }
                    _id('out2').innerHTML = '<br>Selected 2: ' + e.innerText + '/' + month + '/' + year;
                    _id('sel2text').innerHTML = e.innerText + '-' + month + '-' + year;
                }
                if(stop){ go=0; }

            })


        }

        // both selections exist
        else {
            var td = e.parentNode.parentNode.querySelectorAll('td');
            _for(td, function(e){ e.classList.remove('range','disabled'); });

            sel1.removeAttribute('class');
            sel1.removeAttribute('id');
            if(sel2 !== null){
                sel2.removeAttribute('class');
                sel2.removeAttribute('id');
            }

        } //end else/if

    } //userSelect(e);













    /*-----------------------------------------------------

     GET MONTH DATA

     -----------------------------------------------------*/

    function getMonth(year,month){

        /* Expects month to be in 1-12 index based. */
        var monthInformation = function(year, month){
            /* Create a date. Usually month in JS is 0-11 index based but here is a hack that can be used to calculate total days in a month */
            var date = new Date(year, month, 0);
            /* Get the total number of days in a month */
            this.totalDays = date.getDate();
            /* End day of month. Like Saturday is end of month etc. 0 means Sunday and 6 means Saturday */
            this.endDay = date.getDay();
            date.setDate(0);
            /* Start day of month. Like Saturday is start of month etc. 0 means Sunday and 6 means Saturday */
            this.startDay = date.getDay();
            /* Here we generate days for 42 cells of a Month */
            this.days = [];
            /* Here we calculate previous month dates for placeholders if starting day is not Sunday */
            var prevMonthDays = 0;
            if(this.startDay !== 0) {
                prevMonthDays = new Date(year, month - 1, 0).getDate() - this.startDay;
            }
            /* This is placeholder for next month. If month does not end on Saturday, placeholders for next days to fill other cells */
            var count = 0;
            // 42 = 7 columns * 6 rows. This is the standard number. Verify it with any standard Calendar
            for(var i = 0; i < 42; i++) {
                var day = {};
                /* So start day is not Sunday, so we can display previous month dates. For that below we identify previous month dates */
                if(i < this.startDay) {
                    day.date = (prevMonthDays = prevMonthDays + 1);
                    /* belong to next month dates. So, month does not end on Saturday. So here we get next month dates as placeholders */
                } else if(i > this.totalDays + (this.startDay - 1)) {
                    day.date = (count = count + 1);
                    /* belong to current month dates. */
                } else {
                    day.date = (i - this.startDay) + 1;
                }
                this.days[this.days.length] = day.date;
            }
        };
        // ini


        /* Usage below */
        var m = {};
        monthInformation.call(m, year, month);


        var days = m.days,
            startDay = m.startDay,
            endDay = m.endDay,
            totalDays = m.totalDays,
            len = days.length,
            key, str = '', i=0,
            t = $('#t');

        //console.clear();
        //console.log(m);

        str += '<table>';
        str += '<thead><tr><td>Mon</td><td>Tue</td><td>Wed</td><td>Thu</td><td>Fri</td><td>Sat</td><td>Sun</td></tr></thead><tbody>';

        for(key in days){
            i++;

            if(i === 1) str += '<tr>';

            //if( key < startDay || key > totalDays ) { str += '<td class="notCurMonth"><i>'+days[key]+'</i></td>'; }
            //else { str += '<td><i>'+days[key]+'</i></td>'; }

            str += '<td><i>'+days[key]+'</i></td>';

            if(i === 7) { str += '</tr>'; i=0; }

        }
        str += '</tbody></table>';
        $('#cal').append(str);



    } // end getMonth()

// months array (0 based index)
    var monthArr = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december'
    ]

    /* INIT */
    var date = new Date();
    var month = date.getMonth(),
        year = date.getFullYear();

    getMonth(month, year);
    $('#month').text( monthArr[month] + ' ' + year); // set month text

    function bind(month,year){
        var tb = _id('cal');
        $(tb).on('click', 'td', function(){ userSelect(this,null,month,year); });

        // next month
        $('#disp').on('click', 'div', function(){
            var t = this;
            if(t.id == 'next') {
                month++;
                if(month>12){ year++; month=1; } // switch year and reset month
            }
            else {
                month--;
                if(month<1){ year--; month=12; } // switch year and reset month
            }

            $('table').remove();
            getMonth(month,year);
            $('#month').text( monthArr[month-1] + ' ' + year);
        })

    };

    bind(month,year);

})(jQuery, window, document); // end() init