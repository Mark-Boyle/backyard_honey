class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]
  before_action :set_product, only: [:create]

  def index
    @orders = Order.all
    @products = Product.all
  end

  def edit
  end

  def new
    @order = Order.new
  end

  def show
  end

  def create
    @order = current_user.orders.new(order_params)
    if @order.save
      redirect_to @order
    else
      render :new
    end
  end

  def success
    @product = Product.find(params[:product_id])
  end

  def webhook
    payment_intent_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_intent_id)
    product_id = payment.metadata.product_id
    user_id = payment.metadata.user_id
    puts " "
    puts product_id
    puts ' '
    Order.create(user_id: user_id, product_id: product_id)

  end

  private     #private means that the following methods are only used in this controller.

  def set_product
    @product = Product.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_id, :product_id)
  end
end
