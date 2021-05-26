class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]   #Ensures that the user needs to be logged in to be able to create a new product or edit an existing one.
  before_action :set_product, only: [:show, :edit, :update, :destroy] #Determines the product for the show, edit, update and destroy methods.

  def index
    #Uses eager loading to get all the products in the Product model.
    @products = Product.all.includes(:user).with_attached_picture
  end

  #Goes to edit.html.erb to edit an existing product. (/product/:id/edit)
  def edit
  end

  #Creates a new product in the Product Model
  def new
    @product = Product.new
  end

  def show
    stripe_session = Stripe::Checkout::Session.create(               #Creating a stripe session.
      payment_method_types: ['card'],                                #Creates the payment method options. I'm only allowing card payments.
      client_reference_id: current_user ? current_user.id : nil,     #Sets the client reference id for stripe to the id of the user if there is a user logged in.
      customer_email: current_user ? current_user.email : nil,       #Sets the email for stripe to the email of the user if there is a user logged in.
      line_items:[{ 
        amount: (@product.price * 100).to_i,       #Stripe only deals in cents, so the product price needs to be converted to cents and made into an integer.
        name: @product.name,
        description: @product.description,
        currency: 'aud',
        quantity: 1,
       }],
       payment_intent_data: { 
         metadata: { 
           product_id: @product.id,
           user_id: current_user ? current_user.id : nil
          }
        },
        success_url: "#{root_url}payments/success?productId=#{@product.id}",
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

  #To Delete a Product
  def destroy
    @product.destroy
    flash[:alert] = 'Successfully Deleted'
    redirect_to products_path
  end

  #To create a new product
  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new
    end
  end

  private    #private means that the following methods are only used in this controller.

  def set_product
    @product = Product.find(params[:id])   #Sets the product instance variable to the product that is provide by the params.
  end

  def product_params
    params.require(:product).permit(:name, :price, :size, :location, :description, :date_harvested, :picture)  #Allows which params are to be accepted for the product model.
  end
end
