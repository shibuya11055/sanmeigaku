publishable_key = Rails.application.credentials.dig(:stripe, :publishable_key)
secret_key = Rails.application.credentials.dig(:stripe, :secret_key)

Rails.application.configure do
  config.stripe = {
    publishable_key: publishable_key,
    secret_key: secret_key
  }
end

Stripe.api_key = secret_key
