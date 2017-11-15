function supportAjaxUploadWithProgress() {
  return supportFileAPI() && supportAjaxUploadProgressEvents() && supportFormData();
  // Is the File API supported?
  function supportFileAPI() {
    var fi = document.createElement('INPUT');
    fi.type = 'file';
    return 'files' in fi;
  };

  function supportAjaxUploadProgressEvents() {
    var xhr = new XMLHttpRequest();
    return !! (xhr && ('upload' in xhr) && ('onprogress' in xhr.upload));
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
  jqXHR_request = $.ajax({
    url: uri,
    data: formData,
    dataType: 'html',
    type: "POST",
    async: false,
    contentType: false,
    processData: false,
    beforeSend: function(jqXHR, options){
      console.log("TODO Upload started");
    },
    error: function(jqXHR, textStatus, errorThrown){
      console.log("Something happened");
    },
    success: function(data, status, jqXHR){
      url = jqXHR.getResponseHeader('Location');
      if(url){
        window.location = url
      }
    }
  })
}

$(document).ready(function() {
  if (supportAjaxUploadWithProgress()) {
    // Disable turbolinks
    sync_ajax_form_elements = $("form[data-ajax-sync='true']");
    console.log(sync_ajax_form_elements);

    // Init the Ajax form submission on each element with data-ajax-sync attr
    initFullFormAjaxUpload(sync_ajax_form_elements);
  }
});
