window.addEventListener("load", function () {
    $(document).on("click", ".container-mountain #continue", nextStep);
    $(document).on("click", ".container-mountain #continue2", nextStep2);
    $(document).on("click", ".container-mountain #continue3", nextStep3);
    $(document).on("click", ".container-mountain #continue4", nextStep4);
    $(document).on("click", ".container-mountain #prev", prevStep);
    $(document).on("click", ".container-mountain #prev2", prevStep2);
    $(document).on("click", ".container-mountain #prev3", prevStep3);
    $(document).on("click", ".container-mountain #prev4", prevStep4);

    function nextStep(e) {
      updateTab("second", "dot2", e);
    }

    function prevStep(e) {
      updateTab("first", "dot1", e);
    }

    function nextStep2(e) {
      updateTab("third", "dot3", e);
    }

    function prevStep2(e) {
      updateTab("second", "dot2", e);
    }

    function nextStep3(e) {
      updateTab("fourth", "dot4", e);
    }

    function prevStep3(e) {
      updateTab("third", "dot3", e);
    }

    function nextStep4(e) {
      updateTab("fifth", "dot5", e);
    }

    function prevStep4(e) {
      updateTab("fourth", "dot4", e);
    }

    function updateTab(sectionId, dotId, e) {
      goToSection(sectionId);
      setCurrentDotActive(dotId);
      e.preventDefault();
    }

    function goToSection(sectionId) {
      document.getElementById("first").style.display = "none";
      document.getElementById("second").style.display = "none";
      document.getElementById("third").style.display = "none";
      document.getElementById("fourth").style.display = "none";
      document.getElementById("fifth").style.display = "none";
      document.getElementById(sectionId).style.display = "inline";
    }

    function setCurrentDotActive(dotId) {
      document.getElementById("dot1").style.opacity = "0.3";
      document.getElementById("dot2").style.opacity = "0.3";
      document.getElementById("dot3").style.opacity = "0.3";
      document.getElementById("dot4").style.opacity = "0.3";
      document.getElementById("dot5").style.opacity = "0.3";
      document.getElementById(dotId).style.opacity = "1";
    }
});
