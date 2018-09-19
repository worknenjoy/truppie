function CalendarApp(date, apts, aptsDates) {

    if (!(date instanceof Date)) {
        date = new Date();
    }

    this.days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    this.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    this.quotes = ['Whatever the mind of man can conceive and believe, it can achieve. –Napoleon Hill', 'Strive not to be a success, but rather to be of value. –Albert Einstein', 'Two roads diverged in a wood, and I—I took the one less traveled by, And that has made all the difference.  –Robert Frost', 'I attribute my success to this: I never gave or took any excuse. –Florence Nightingale', 'You miss 100% of the shots you don’t take. –Wayne Gretzky', 'The most difficult thing is the decision to act, the rest is merely tenacity. –Amelia Earhart', 'Every strike brings me closer to the next home run. –Babe Ruth', 'Definiteness of purpose is the starting point of all achievement. –W. Clement Stone', 'Life isn’t about getting and having, it’s about giving and being. –Kevin Kruse', 'Life is what happens to you while you’re busy making other plans. –John Lennon', 'We become what we think about. –Earl Nightingale', 'Life is 10% what happens to me and 90% of how I react to it. –Charles Swindoll', 'The most common way people give up their power is by thinking they don’t have any. –Alice Walker', 'The mind is everything. What you think you become.  –Buddha', 'Winning isn’t everything, but wanting to win is. –Vince Lombardi', 'Every child is an artist.  The problem is how to remain an artist once he grows up. –Pablo Picasso', ' You can never cross the ocean until you have the courage to lose sight of the shore. –Christopher Columbus', 'I’ve learned that people will forget what you said, people will forget what you did, but people will never forget how you made them feel. –Maya Angelou', 'Either you run the day, or the day runs you. –Jim Rohn', 'Whether you think you can or you think you can’t, you’re right. –Henry Ford', 'The two most important days in your life are the day you are born and the day you find out why. –Mark Twain', 'Whatever you can do, or dream you can, begin it.  Boldness has genius, power and magic in it. –Johann Wolfgang von Goethe', 'The best revenge is massive success. –Frank Sinatra', 'People often say that motivation doesn’t last. Well, neither does bathing.  That’s why we recommend it daily. –Zig Ziglar', 'Life shrinks or expands in proportion to one’s courage. –Anais Nin', 'If you hear a voice within you say “you cannot paint,” then by all means paint and that voice will be silenced. –Vincent Van Gogh', 'There is only one way to avoid criticism: do nothing, say nothing, and be nothing. –Aristotle', 'Ask and it will be given to you; search, and you will find; knock and the door will be opened for you. –Jesus', 'The only person you are destined to become is the person you decide to be. –Ralph Waldo Emerson', 'Go confidently in the direction of your dreams.  Live the life you have imagined. –Henry David Thoreau',  'Few things can help an individual more than to place responsibility on him, and to let him know that you trust him.  –Booker T. Washington'];
    this.apts = apts || [
        {
            name: 'Finish this web app',
            endTime: new Date(2016, 4, 30, 23),
            startTime: new Date(2016, 4, 30, 21),
            day: new Date(2016, 4, 30).toString()
        },
        {
            name: 'My Birthday!',
            endTime: new Date(2016, 4, 1, 23, 59),
            startTime: new Date(2016, 4, 1, 0),
            day: new Date(2016, 4, 1).toString()
        },

    ];

    this.aptDates = aptsDates || [new Date(2016, 4, 30).toString(),new Date(2016, 4, 1).toString()];

    this.calDaySelected = null;

    this.calendar = document.getElementById("calendar-app");

    this.calendarView = document.getElementById("dates");

    this.calendarMonthDiv = document.getElementById("calendar-month");
    this.calendarMonthLastDiv = document.getElementById("calendar-month-last");
    this.calendarMonthNextDiv = document.getElementById("calendar-month-next");

    this.dayInspirationalQuote = document.getElementById("inspirational-quote");

    this.todayIsSpan = document.getElementById("footer-date");
    // this.eventsCountSpan = document.getElementById("footer-events");
    this.dayViewEle = document.getElementById("day-view");
    this.dayViewExitEle = document.getElementById("day-view-exit");
    this.dayViewDateEle = document.getElementById("day-view-date");
    this.addDayEventEle = document.getElementById("add-event");
    this.dayEventsEle = document.getElementById("day-events");

    this.dayEventAddForm = {
        cancelBtn: document.getElementById("add-event-cancel"),
        addBtn: document.getElementById("add-event-save"),
        nameEvent:  document.getElementById("input-add-event-name"),
        startTime:  document.getElementById("input-add-event-start-time"),
        endTime:  document.getElementById("input-add-event-end-time"),
        startAMPM:  document.getElementById("input-add-event-start-ampm"),
        endAMPM:  document.getElementById("input-add-event-end-ampm")
    };
    this.dayEventsList = document.getElementById("day-events-list");
    this.dayEventBoxEle = document.getElementById("add-day-event-box");

    /* Start the app */
    this.showView(date);
    this.addEventListeners();
}

CalendarApp.prototype.addEventListeners = function(){

    this.calendar.addEventListener("click", this.mainCalendarClickClose.bind(this));
    this.todayIsSpan.addEventListener("click", this.showView.bind(this));
    this.calendarMonthLastDiv.addEventListener("click", this.showNewMonth.bind(this));
    this.calendarMonthNextDiv.addEventListener("click", this.showNewMonth.bind(this));
    this.dayViewExitEle.addEventListener("click", this.closeDayWindow.bind(this));
    this.dayViewDateEle.addEventListener("click", this.showNewMonth.bind(this));
    this.addDayEventEle.addEventListener("click", this.addNewEventBox.bind(this));
    this.dayEventAddForm.cancelBtn.addEventListener("click", this.closeNewEventBox.bind(this));
    this.dayEventAddForm.cancelBtn.addEventListener("keyup", this.closeNewEventBox.bind(this));

    this.dayEventAddForm.startTime.addEventListener("keyup",this.inputChangeLimiter.bind(this));
    this.dayEventAddForm.startAMPM.addEventListener("keyup",this.inputChangeLimiter.bind(this));
    this.dayEventAddForm.endTime.addEventListener("keyup",this.inputChangeLimiter.bind(this));
    this.dayEventAddForm.endAMPM.addEventListener("keyup",this.inputChangeLimiter.bind(this));
    this.dayEventAddForm.addBtn.addEventListener("click",this.saveAddNewEvent.bind(this));

};
CalendarApp.prototype.showView = function(date){
    if ( !date || (!(date instanceof Date)) ) date = new Date();
    var now = new Date(date),
        y = now.getFullYear(),
        m = now.getMonth();
    var today = new Date();

    var lastDayOfM = new Date(y, m + 1, 0).getDate();
    var startingD = new Date(y, m, 1).getDay();
    var lastM = new Date(y, now.getMonth()-1, 1);
    var nextM = new Date(y, now.getMonth()+1, 1);

    this.calendarMonthDiv.classList.remove("cview__month-activate");
    this.calendarMonthDiv.classList.add("cview__month-reset");

    while(this.calendarView.firstChild) {
        this.calendarView.removeChild(this.calendarView.firstChild);
    }

    // build up spacers
    for ( var x = 0; x < startingD; x++ ) {
        var spacer = document.createElement("div");
        spacer.className = "cview--spacer";
        this.calendarView.appendChild(spacer);
    }

    for ( var z = 1; z <= lastDayOfM; z++ ) {

        var _date = new Date(y, m ,z);
        var day = document.createElement("div");
        day.className = "cview--date";
        day.textContent = z;
        day.setAttribute("data-date", _date);
        day.onclick = this.showDay.bind(this);

        // check if todays date
        if ( z == today.getDate() && y == today.getFullYear() && m == today.getMonth() ) {
            day.classList.add("today");
        }

        // check if has events to show
        if ( this.aptDates.indexOf(_date.toString()) !== -1 ) {
            day.classList.add("has-events");
        }

        this.calendarView.appendChild(day);
    }

    var _that = this;
    setTimeout(function(){
        _that.calendarMonthDiv.classList.add("cview__month-activate");
    }, 50);

    this.calendarMonthDiv.textContent = this.months[now.getMonth()] + " " + now.getFullYear();
    this.calendarMonthDiv.setAttribute("data-date", now);


    this.calendarMonthLastDiv.textContent = "← " + this.months[lastM.getMonth()];
    this.calendarMonthLastDiv.setAttribute("data-date", lastM);

    this.calendarMonthNextDiv.textContent = this.months[nextM.getMonth()] + " →";
    this.calendarMonthNextDiv.setAttribute("data-date", nextM);

}
CalendarApp.prototype.showDay = function(e, dayEle) {
    e.stopPropagation();
    if ( !dayEle ) {
        dayEle = e.currentTarget;
    }
    var dayDate = new Date(dayEle.getAttribute('data-date'));

    this.calDaySelected = dayEle;

    this.openDayWindow(dayDate);
};
CalendarApp.prototype.openDayWindow = function(date){

    var now = new Date();
    var day = new Date(date);
    this.dayViewDateEle.textContent = this.days[day.getDay()] + ", " + this.months[day.getMonth()] + " " + day.getDate() + ", " + day.getFullYear();
    this.dayViewDateEle.setAttribute('data-date', day);
    this.dayViewEle.classList.add("calendar--day-view-active");

    /* Contextual lang changes based on tense. Also show btn for scheduling future events */
    var _dayTopbarText = '';
    if ( day < new Date(now.getFullYear(), now.getMonth(), now.getDate())) {
        _dayTopbarText = "had ";
        this.addDayEventEle.style.display = "none";
    } else {
        _dayTopbarText = "have ";
        this.addDayEventEle.style.display = "inline";
    }
    this.addDayEventEle.setAttribute("data-date", day);

    var eventsToday = this.showEventsByDay(day);
    if ( !eventsToday ) {
        _dayTopbarText += "no ";
        var _rand = Math.round(Math.random() * ((this.quotes.length - 1 ) - 0) + 0);
        this.dayInspirationalQuote.textContent = this.quotes[_rand];
    } else {
        _dayTopbarText += eventsToday.length + " ";
        this.dayInspirationalQuote.textContent = null;
    }
    //this.dayEventsList.innerHTML = this.showEventsCreateHTMLView(eventsToday);
    while(this.dayEventsList.firstChild) {
        this.dayEventsList.removeChild(this.dayEventsList.firstChild);
    }

    this.dayEventsList.appendChild(this.showEventsCreateElesView(eventsToday));


    this.dayEventsEle.textContent = _dayTopbarText + "events on " + this.months[day.getMonth()] + " " + day.getDate() + ", " + day.getFullYear();


};

CalendarApp.prototype.showEventsCreateElesView = function(events) {
    var ul = document.createElement("ul");
    ul.className = 'day-event-list-ul';
    events = this.sortEventsByTime(events);
    var _this = this;
    events.forEach(function(event){
        var _start = new Date(event.startTime);
        var _end = new Date(event.endTime);
        var idx = event.index;
        var li = document.createElement("li");
        li.className = "event-dates";
        // li.innerHtml
        var html = "<span class='start-time'>" + _start.toLocaleTimeString(navigator.language,{hour: '2-digit', minute:'2-digit'}) + "</span> <small>até</small> ";
        html += "<span class='end-time'>" + _end.toLocaleTimeString(navigator.language,{hour: '2-digit', minute:'2-digit'}) + ( (_end.getDate() != _start.getDate()) ? ' <small>on ' + _end.toLocaleDateString() + "</small>" : '') +"</span>";


        html += "<span class='event-name'>" + event.name + "</span>";

        var div = document.createElement("div");
        div.className = "event-dates";
        div.innerHTML = html;

        var deleteBtn = document.createElement("span");
        var deleteText = document.createTextNode("");
        deleteBtn.className = "event-delete";
        deleteBtn.setAttribute("data-idx", idx);
        deleteBtn.appendChild(deleteText);
        deleteBtn.onclick = _this.addEvent.bind(_this);

        div.appendChild(deleteBtn);

        li.appendChild(div);
        ul.appendChild(li);
    });
    return ul;
};
CalendarApp.prototype.addEvent = function(e) {
    console.log('event added');
    var deleted = this.apts.splice(e.currentTarget.getAttribute("data-idx"),1);
    var deletedDate = new Date(deleted[0].day);
    var anyDatesLeft = this.showEventsByDay(deletedDate);
    if ( anyDatesLeft === false ) {
        // safe to remove from array
        var idx = this.aptDates.indexOf(deletedDate.toString());
        if (idx >= 0) {
            this.aptDates.splice(idx,1);
            // remove dot from calendar view
            var ele = document.querySelector('.cview--date[data-date="'+ deletedDate.toString() +'"]');
            if ( ele ) {
                ele.classList.remove("has-events");
            }
        }
    }
    this.openDayWindow(deletedDate);;
};
CalendarApp.prototype.sortEventsByTime = function(events) {
    if (!events) return [];
    return events.sort(function compare(a, b) {
        if (new Date(a.startTime) < new Date(b.startTime)) {
            return -1;
        }
        if (new Date(a.startTime) > new Date(b.startTime)) {
            return 1;
        }
        // a must be equal to b
        return 0;
    });
};
CalendarApp.prototype.showEventsByDay = function(day) {
    var _events = [];
    this.apts.forEach(function(apt, idx){
        if ( day.toString() == apt.day.toString() ) {
            apt.index = idx;
            _events.push(apt);
        }
    });
    return (_events.length) ? _events : false;
};
CalendarApp.prototype.closeDayWindow = function(){
    this.dayViewEle.classList.remove("calendar--day-view-active");
    this.closeNewEventBox();
};
CalendarApp.prototype.mainCalendarClickClose = function(e){
    if ( e.currentTarget != e.target ) {
        return;
    }

    this.dayViewEle.classList.remove("calendar--day-view-active");
    this.closeNewEventBox();
};
CalendarApp.prototype.addNewEventBox = function(e){
    var target = e.currentTarget;
    this.dayEventBoxEle.setAttribute("data-active", "true");
    this.dayEventBoxEle.setAttribute("data-date", target.getAttribute("data-date"));

};
CalendarApp.prototype.closeNewEventBox = function(e){

    if (e && e.keyCode && e.keyCode != 13) return false;

    this.dayEventBoxEle.setAttribute("data-active", "false");
    // reset values
    this.resetAddEventBox();

};
CalendarApp.prototype.saveAddNewEvent = function() {
    var saveErrors = this.validateAddEventInput();
    if ( !saveErrors ) {
        this.addEvent();
    }
};

CalendarApp.prototype.addEvent = function() {

    var name = this.dayEventAddForm.nameEvent.value.trim();
    var dayOfDate = this.dayEventBoxEle.getAttribute("data-date");
    var dateObjectDay =  new Date(dayOfDate);
    var cleanDates = this.cleanEventTimeStampDates();

    this.apts.push({
        name: name,
        day: dateObjectDay,
        startTime: cleanDates[0],
        endTime: cleanDates[1]
    });
    this.closeNewEventBox();
    this.openDayWindow(dayOfDate);
    this.calDaySelected.classList.add("has-events");
    // add to dates
    if ( this.aptDates.indexOf(dateObjectDay.toString()) === -1 ) {
        this.aptDates.push(dateObjectDay.toString());
    }

};
CalendarApp.prototype.convertTo23HourTime = function(stringOfTime, AMPM) {
    // convert to 0 - 23 hour time
    var mins = stringOfTime.split(":");
    var hours = stringOfTime.trim();
    if ( mins[1] && mins[1].trim() ) {
        hours = parseInt(mins[0].trim());
        mins = parseInt(mins[1].trim());
    } else {
        hours = parseInt(hours);
        mins = 0;
    }
    hours = ( AMPM == 'am' ) ? ( (hours == 12) ? 0 : hours ) : (hours <= 11) ? parseInt(hours) + 12 : hours;
    return [hours, mins];
};
CalendarApp.prototype.cleanEventTimeStampDates = function() {

    var startTime = this.dayEventAddForm.startTime.value.trim() || this.dayEventAddForm.startTime.getAttribute("placeholder") || '8';
    var startAMPM = this.dayEventAddForm.startAMPM.value.trim() || this.dayEventAddForm.startAMPM.getAttribute("placeholder") || 'am';
    startAMPM = (startAMPM == 'a') ? startAMPM + 'm' : startAMPM;
    var endTime = this.dayEventAddForm.endTime.value.trim() || this.dayEventAddForm.endTime.getAttribute("placeholder") || '9';
    var endAMPM = this.dayEventAddForm.endAMPM.value.trim() || this.dayEventAddForm.endAMPM.getAttribute("placeholder") || 'pm';
    endAMPM = (endAMPM == 'p') ? endAMPM + 'm' : endAMPM;
    var date = this.dayEventBoxEle.getAttribute("data-date");

    var startingTimeStamps = this.convertTo23HourTime(startTime, startAMPM);
    var endingTimeStamps = this.convertTo23HourTime(endTime, endAMPM);

    var dateOfEvent = new Date(date);
    var startDate = new Date(dateOfEvent.getFullYear(), dateOfEvent.getMonth(), dateOfEvent.getDate(), startingTimeStamps[0], startingTimeStamps[1]);
    var endDate = new Date(dateOfEvent.getFullYear(), dateOfEvent.getMonth(), dateOfEvent.getDate(), endingTimeStamps[0], endingTimeStamps[1]);

    // if end date is less than start date - set end date back another day
    if ( startDate > endDate ) endDate.setDate(endDate.getDate() + 1);

    return [startDate, endDate];

};
CalendarApp.prototype.validateAddEventInput = function() {

    var _errors = false;
    var name = this.dayEventAddForm.nameEvent.value.trim();
    var startTime = this.dayEventAddForm.startTime.value.trim();
    var startAMPM = this.dayEventAddForm.startAMPM.value.trim();
    var endTime = this.dayEventAddForm.endTime.value.trim();
    var endAMPM = this.dayEventAddForm.endAMPM.value.trim();

    if (!name || name == null) {
        _errors = true;
        this.dayEventAddForm.nameEvent.classList.add("add-event-edit--error");
        this.dayEventAddForm.nameEvent.focus();
    } else {
        this.dayEventAddForm.nameEvent.classList.remove("add-event-edit--error");
    }

//   if (!startTime || startTime == null) {
//     _errors = true;
//     this.dayEventAddForm.startTime.classList.add("add-event-edit--error");
//   } else {
//      this.dayEventAddForm.startTime.classList.remove("add-event-edit--error");
//   }

    return _errors;


};
var timeOut = null;
var activeEle = null;
CalendarApp.prototype.inputChangeLimiter = function(ele) {

    if ( ele.currentTarget ) {
        ele = ele.currentTarget;
    }
    if (timeOut && ele == activeEle){
        clearTimeout(timeOut);
    }

    var limiter = CalendarApp.prototype.textOptionLimiter;

    var _options = ele.getAttribute("data-options").split(",");
    var _format = ele.getAttribute("data-format") || 'text';
    timeOut = setTimeout(function(){
        ele.value = limiter(_options, ele.value, _format);
    }, 600);
    activeEle = ele;

};
CalendarApp.prototype.textOptionLimiter = function(options, input, format){
    if ( !input ) return '';

    if ( input.indexOf(":") !== -1 && format == 'datetime' ) {

        var _splitTime = input.split(':', 2);
        if (_splitTime.length == 2 && !_splitTime[1].trim()) return input;
        var _trailingTime = parseInt(_splitTime[1]);
        /* Probably could be coded better -- a block to clean up trailing data */
        if (options.indexOf(_splitTime[0]) === -1) {
            return options[0];
        }
        else if (_splitTime[1] == "0" ) {
            return input;
        }
        else if (_splitTime[1] == "00" ) {
            return _splitTime[0] +  ":00";
        }
        else if (_trailingTime < 10 ) {
            return _splitTime[0] + ":" + "0" + _trailingTime;
        }
        else if ( !Number.isInteger(_trailingTime) || _trailingTime < 0 || _trailingTime > 59 )  {
            return _splitTime[0];
        }
        return _splitTime[0] + ":" + _trailingTime;
    }
    if ((input.toString().length >= 3) ) {
        var pad = (input.toString().length - 4) * -1;
        var _hour, _min;
        if (pad == 1) {
            _hour = input[0];
            _min = input[1] + input[2];
        } else {
            _hour = input[0] + input[1];
            _min = input[2] + input[3];
        }

        _hour = Math.max(1,Math.min(12,(_hour)));
        _min = Math.min(59,(_min));
        if ( _min < 10 ) {
            _min = "0" + _min;
        }
        _min = (isNaN(_min)) ? '00' : _min;
        _hour = (isNaN(_hour)) ? '9' : _hour ;

        return _hour + ":" + _min;

    }

    if (options.indexOf(input) === -1) {
        return options[0];
    }

    return input;
};
CalendarApp.prototype.resetAddEventBox = function(){
    this.dayEventAddForm.nameEvent.value = '';
    this.dayEventAddForm.nameEvent.classList.remove("add-event-edit--error");
    this.dayEventAddForm.endTime.value = '';
    this.dayEventAddForm.startTime.value = '';
    this.dayEventAddForm.endAMPM.value = '';
    this.dayEventAddForm.startAMPM.value = '';
};
CalendarApp.prototype.showNewMonth = function(e){
    var date = e.currentTarget.dataset.date;
    var newMonthDate = new Date(date);
    this.showView(newMonthDate);
    this.closeDayWindow();
    return true;
};