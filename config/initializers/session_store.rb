# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :active_record_store, key: '_truppie_session'
Rails.application.config.session_store :redis_session_store, {
    key: '_truppie_session',
    redis: {
        expire_after: 120.minutes,  # cookie expiration
        ttl: 120.minutes,           # Redis expiration, defaults to 'expire_after'
        key_prefix: 'truppie:session:',
        url: Rails.application.secrets[:redis_url]
    }
}