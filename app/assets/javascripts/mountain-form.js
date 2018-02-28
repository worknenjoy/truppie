window.addEventListener("load", function () {
    $(document).on("click", ".container-mountain #continue", nextStep);
    $(document).on("click", ".container-mountain #continue2", nextStep2);
    $(document).on("click", ".container-mountain #continue3", nextStep3);
    $(document).on("click", ".container-mountain #continue4", nextStep4);
    $(document).on("click", ".container-mountain #prev", prevStep);
    $(document).on("click", ".container-mountain #prev2", prevStep2);
    $(document).on("click", ".container-mountain #prev3", prevStep3);
    $(document).on("click", ".container-mountain #prev4", prevStep4);

    // ======== SECTION 1 =============== //

    function nextStep(e) {
        document.getElementById("first").style.display = "none";
        document.getElementById("second").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "1";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();

    }

    // ======== SECTION 2 =============== //

    function prevStep(e) {
        document.getElementById("second").style.display = "none";
        document.getElementById("first").style.display = "inline";

        document.getElementById("dot1").style.opacity = "1";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();
    }

    function nextStep2(e) {
        document.getElementById("second").style.display = "none";
        document.getElementById("third").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "1";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();

    }

    // ======== SECTION 3 =============== //

    function prevStep2(e) {
        document.getElementById("third").style.display = "none";
        document.getElementById("second").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "1";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();
    }

    function nextStep3(e) {
        document.getElementById("third").style.display = "none";
        document.getElementById("fourth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "1";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();

    }

    // ======== SECTION 4 =============== //

    function prevStep3(e) {
        document.getElementById("fourth").style.display = "none";
        document.getElementById("third").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "1";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();
    }

    function nextStep4(e) {
        document.getElementById("fourth").style.display = "none";
        document.getElementById("fifth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "0.3";
        document.getElementById("dot5").style.opacity = "1";
        e.preventDefault();

    }

    // ======== SECTION 5 =============== //

    function prevStep4(e) {
        document.getElementById("fifth").style.display = "none";
        document.getElementById("fourth").style.display = "inline";

        document.getElementById("dot1").style.opacity = "0.3";
        document.getElementById("dot2").style.opacity = "0.3";
        document.getElementById("dot3").style.opacity = "0.3";
        document.getElementById("dot4").style.opacity = "1";
        document.getElementById("dot5").style.opacity = "0.3";
        e.preventDefault();
    }

});
