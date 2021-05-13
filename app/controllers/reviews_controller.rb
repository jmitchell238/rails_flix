class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    set_movie
    @reviews = @movie.reviews
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    set_movie
    @review = @movie.reviews.new
  end

  def create
    set_movie
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_path(@movie), notice: 'Review Posted Successfully!'
    else
      render :new
    end
  end

  def edit
    @review = set_review
  end

  def update
    @review = set_review
    if @review.update(review_params)
      redirect_to movie_reviews_path, notice: "Review Successfully Updated!"
    else
      render :edit
    end
  end

  def destroy
    @review = set_review
    @review.destroy
    redirect_to movie_reviews_path(@movie), alert: "Review Successfully Deleted!"
  end

  private
  def review_params
    params.require(:review).permit(:stars, :comment)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

  def set_review
    Review.find(params[:id])
  end

end
