class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def index
  end

  def edit
  end

  def new
  end

  def show
  end

  def update
  end

  def destroy
  end

  def create
  end

  def success
    @product = Product.find(params[:productId])
  end

  def webhook
    payment_intent_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
    product_id = payment.metadata.listing_id
    buyer_id = payment.metadata.user_id

    Order.create(
      user_id: buyer_id, 
      product_id: product_id, 
      # payment_intent_id: payment_intent_id, 
      # receipt_url: payment.charges.data[0].receipt_url
    )

    # listing = Listing.find(listing_id)
    # listing.update(status: 'purchased')
  end
end
