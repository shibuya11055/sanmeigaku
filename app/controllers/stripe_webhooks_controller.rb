class StripeWebhooksController < ApplicationController
  # WebhookはCSRF保護をスキップ
  skip_before_action :verify_authenticity_token
  # Webhookは認証不要
  skip_before_action :authenticate_user!

  def receive
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    event = nil
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    case event['type']
    when 'customer.subscription.updated'
      handle_subscription_update(event['data']['object'])
    end

    render json: { message: 'success' }
  end

  private

  def handle_subscription_update(subscription_obj)
    stripe_id = subscription_obj['id']
    status = subscription_obj['status']
    ended_at = subscription_obj['ended_at']

    sub = Subscription.find_by(stripe_subscription_id: stripe_id)
    return unless sub

    # Stripeのstatusをそのまま保存
    sub.update(status: status)
    sub.update(end_date: Time.at(ended_at).localtime) if ended_at.present?
  end
end
