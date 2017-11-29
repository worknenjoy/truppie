function open_whatsapp_chat(phone_number) {
  var api_url = "https://api.whatsapp.com/send?phone="
  var full_url = api_url + phone_number

  window.open(full_url, "_blank");
};
