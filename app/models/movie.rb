class Movie < ActiveRecord::Base
  belongs_to :user
  has_many :actor_movies
  has_many :actors, :through => :actor_movies
  has_many :movie_genres
  has_many :genres, :through => :movie_genres
  validates :title, presence: true, length: { minimum: 2 }
  validates :year, presence: true, length: { minimum: 4 }

  def slug
  	x = self.title.to_s.downcase.gsub(/[^a-z ]/,"").gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = Movie.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end
