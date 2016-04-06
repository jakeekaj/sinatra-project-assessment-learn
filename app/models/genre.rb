class Genre < ActiveRecord::Base
  belongs_to :user
  has_many :actor_genres
  has_many :actors, :through => :actor_genres
  has_many :movie_genres
  has_many :genres, :through => :movie_genres
  has_many :show_genres
  has_many :shows, :through => :show_genres

  def slug
  	x = self.username
  	x = x.downcase.gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = Genre.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end