class Movie < ActiveRecord::Base
	extend FriendlyId
	friendly_id :title, use: :slugged

	mount_uploader :image, PosterUploader

	has_many :reviews, dependent: :destroy
	belongs_to :user

	validates :title, :description, :director, :rating, :movie_length, :image, presence: true
end
