class ReviewsController < ApplicationController
	before_action :authenticate_user!

	def create
		@movie = Movie.friendly.find(params[:movie_id])
		@review = @movie.reviews.new(review_params)
		@review.user_id = current_user.id
		if @review.save
			redirect_to @movie, notice: "Thank you for the review."
		else
			redirect_to @movie, alert: "Comment can't be blank."
		end
	end

	private 

	def review_params
		params.require(:review).permit(:comment, :rating, :movie_id)
	end
end
