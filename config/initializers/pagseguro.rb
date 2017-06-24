PagSeguro.configure do |config|
  #config.email = "alexanmtz@gmail.com"
  #config.token = "130482335F960EA27EA82987F9FE59D3"
  config.app_key       = "CDEF210C5C5C6DFEE4E36FBE9DB6F509"
  config.app_id       = "truppie"
  #config.environment = :sandbox
  config.environment = :production
  config.encoding    = "UTF-8" # ou ISO-8859-1. O padrão é UTF-8.
end