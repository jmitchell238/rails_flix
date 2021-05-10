class MoviesController < ApplicationController

  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]


  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @movie = Movie.find(params[:id])
    @review = Review.new
    @fans = @movie.fans
    @genres = @movie.genres
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Movie Successfully Updated!'
    else
      render :edit
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: 'Movie Successfully Created!'
    else
      render :new
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_url, alert: 'Movie Successfully Deleted!'
  end

  private
  def movie_params
    params.require(:movie).
      permit(:title, :description, :rating,
             :released_on, :total_gross, :director, :duration, :image_file_name,
             genre_ids: [])
  end

  def movies_filter
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end
end
