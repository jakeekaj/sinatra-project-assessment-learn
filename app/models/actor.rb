class Actor < ActiveRecord::Base
  belongs_to :user
  has_many :actor_genres
  has_many :genres, :through => :actor_genres
  has_many :actor_movies
  has_many :movies, :through => :actor_movies
  has_many :actor_shows
  has_many :shows, :through => :actor_shows

  def slug
  	x = self.username
  	x = x.downcase.gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = Actor.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end
