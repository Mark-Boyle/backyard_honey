class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
  end

  def edit
  end

  def new
    @product = Product.new
  end

  def show
  end

  def update
  end

  def destroy
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
    params.require(:product).permit(:name, :price, :size, :location, :description, :date_harvested)
  end

end
