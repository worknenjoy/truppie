function supportAjaxFormDataUpload() {
  return supportFileAPI() && supportFormData();
  // Is the File API supported?
  function supportFileAPI() {
    var fi = document.createElement('INPUT');
    fi.type = 'file';
    return 'files' in fi;
  };

  function supportFormData() {
    return !! window.FormData;
  }
}

function initFullFormAjaxUpload(form_selector) {
  $(form_selector).on('submit', function(event){
    event.preventDefault();
    form = $(this)[0];

    formData = new FormData(form);
    action = form.getAttribute('action');

    makeAjaxRequest(formData, action);

    return false;
  });
}

function makeAjaxRequest(formData, uri) {
  var jqXHRLoadingElem = $('.track-loading');
  var jqXHR_request = $.ajax({
    url: uri,
    data: formData,
    // Since turbolinks is set the server returns a script response. It won't be used though.
    // Setting to html and ignoring it instead.
    dataType: 'html',
    type: "POST",
    async: true,
    contentType: false,
    processData: false,
    beforeSend: function(jqXHR, options){
      jqXHRLoadingElem.show('fast');
      // # TODO Disable any other actions
    },
    error: function(jqXHR, textStatus, errorThrown){
      console.log("Something happened when requesting " + uri);
    },
    success: function(data, status, jqXHR){
      url = jqXHR.getResponseHeader('Location');
      if(url){
        window.location = url
      }
    },
    complete: function(jqXHR, status){
      jqXHRLoadingElem.hide();
    }
  })
}

$(document).ready(function() {
  if (supportAjaxFormDataUpload()) {
    // Disable turbolinks
    sync_ajax_form_elements = $("form[data-ajax-sync='true']");

    // Init the Ajax form submission on each element with data-ajax-sync attr
    initFullFormAjaxUpload(sync_ajax_form_elements);
  }
});
