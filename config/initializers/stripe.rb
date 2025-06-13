Rails.application.configure do
  if Rails.env.development?
    config.stripe = {
      publishable_key: Rails.application.credentials.stripe[:publishable_key],
      secret_key: Rails.application.credentials.stripe[:secret_key]
    }
  elsif Rails.env.production?
    config.stripe = {
      publishable_key: Rails.application.credentials.stripe[:prod_publishable_key],
      secret_key: Rails.application.credentials.stripe[:prod_secret_key]
    }
  end
end

if Rails.env.development?
  Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
else
  Stripe.api_key = Rails.application.credentials.stripe[:prod_secret_key]
end
