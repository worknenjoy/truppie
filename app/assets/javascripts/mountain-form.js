window.addEventListener("load", function () {

    document.getElementById("dot1").style.opacity = "1";
    document.getElementById("dot2").style.opacity = "0.3";
    document.getElementById("dot3").style.opacity = "0.3";
    document.getElementById("dot4").style.opacity = "0.3";
    document.getElementById("dot5").style.opacity = "0.3";

    var next = document.getElementById("continue");
    next.addEventListener("click", nextStep);

    var next2 = document.getElementById("continue2");
    next2.addEventListener("click", nextStep2);

    var next3 = document.getElementById("continue3");
    next3.addEventListener("click", nextStep3);

    var next4 = document.getElementById("continue4");
    next4.addEventListener("click", nextStep4);

    var prev = document.getElementById("prev");
    prev.addEventListener("click", prevStep);

    var prev2 = document.getElementById("prev2");
    prev2.addEventListener("click", prevStep2);

    var prev3 = document.getElementById("prev3");
    prev3.addEventListener("click", prevStep3);

    var prev4 = document.getElementById("prev4");
    prev4.addEventListener("click", prevStep4);

    // ======== SECTION 1 =============== //

    function nextStep() {
        document.getElementById("first").style.display = "none";
        document.getElementById("second").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "1";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";

    }

    // ======== SECTION 2 =============== //

    function prevStep() {
        document.getElementById("second").style.display = "none";
        document.getElementById("first").style.display = "inline";

        document.getElementById("dot1").style.opacity = "1";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
    }

    function nextStep2() {
        document.getElementById("second").style.display = "none";
        document.getElementById("third").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "1";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";

    }


    // ======== SECTION 3 =============== //

    function prevStep2() {
        document.getElementById("third").style.display = "none";
        document.getElementById("second").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "1";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
    }

    function nextStep3() {
        document.getElementById("third").style.display = "none";
        document.getElementById("fourth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "1";
        document.getElementById("dot5").style.opacity = "0.3";

    }

    // ======== SECTION 4 =============== //

    function prevStep3() {
        document.getElementById("fourth").style.display = "none";
        document.getElementById("third").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "1";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
    }

    function nextStep4() {
        document.getElementById("fourth").style.display = "none";
        document.getElementById("fifth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "1";

    }

    // ======== SECTION 5 =============== //

    function prevStep4() {
        document.getElementById("fifth").style.display = "none";
        document.getElementById("fourth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "1";
        document.getElementById("dot5").style.opacity = "0.3";
    }

});