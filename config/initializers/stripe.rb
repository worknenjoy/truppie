Rails.configuration.stripe = {
  :publishable_key => secret_key = Rails.application.secrets[:stripe_pubkey],
  :secret_key      => secret_key = Rails.application.secrets[:stripe_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_base = "https://api-tls12.stripe.com"