class MoviesController < ApplicationController

	before_action :set_movie, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@movies = current_user.movies.all
	end

	def new
		@movie = current_user.movies.build
	end

	def create
		@movie = current_user.movies.build(movie_params)
		if @movie.save
			redirect_to @movie, notice: "Movie created sucessfull."
		else
			render "new"
		end
	end

	def show
		if  @movie.reviews.blank?
			@rate = 0
		else
			@rate = @movie.reviews.average(:rating)
		end
	end

	def edit
		verify_user
	end

	def update
		@movie.slug = params[:title]
		if @movie.update(movie_params)
			redirect_to @movie, notice: "Movie edited"
		else
			render "edit"
		end
	end

	def destroy
		@movie.destroy
		redirect_to movies_path, notice: "Movie deleted"
	end

	private 

	def movie_params
		params.require(:movie).permit(:title, :description, :director, :movie_length, :rating, :image, :slug)
	end

	def set_movie
		@movie = Movie.friendly.find(params[:id])
	end

	def verify_user
		if current_user.id != @movie.user_id
			raise ActionController::RoutingError.new('Not Found')
		end
	end
end
