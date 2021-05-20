class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :edit]

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
