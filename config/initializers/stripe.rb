Rails.configuration.stripe = {
  :publishable_key => Rails.application.secrets[:stripe_pubkey],
  :secret_key      => Rails.application.secrets[:stripe_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]