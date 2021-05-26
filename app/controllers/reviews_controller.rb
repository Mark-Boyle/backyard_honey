class ReviewsController < ApplicationController
  before_action :set_product, only: [:new, :create]

  def new
    @review = Review.new
  end

  def create
    @review = current_user.reviews.new(review_params)
    if @review.save
      redirect_to @review
    else
      render :new
    end
  end

  private   #private means that the following methods are only used in this controller.

  def set_product
    @product = Product.find(params[:id])
  end
  
  def review_params
    params.require(:review).permit(:score, :description, :product_id, :user_id)
  end
end
