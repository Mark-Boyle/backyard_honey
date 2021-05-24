class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.includes(:user).with_attached_picture
  end

  def edit
  end

  def new
    @product = Product.new
  end

  def show
    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      client_reference_id: current_user ? current_user.id : nil,
      customer_email: current_user ? current_user.email : nil,
      line_items:[{ 
        amount: (@product.price * 100).to_i,
        name: @product.name,
        description: @product.description,
        currency: 'aud',
        quantity: 1,
        # images: @product.picture.empty? ? nil : [@product.picture]
       }],
       payment_intent_data: { 
         metadata: { 
           listing_id: @product.id,
           user_id: current_user ? current_user.id : nil
          }
        },
        success_url: "#{root_url}purchases/success?productId=#{@product.id}",
        cancel_url: "#{root_url}products"
    )
    @session_id = stripe_session.id
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:alert] = 'Successfully Deleted'
    redirect_to products_path
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  private 

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :size, :location, :description, :date_harvested, :picture)
  end

end
