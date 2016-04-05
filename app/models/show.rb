class Show < ActiveRecord::Base
  belongs_to :user
  has_many :actor_shows
  has_many :actors, :through => :actor_shows
  has_many :show_genres
  has_many :genres, :through => :show_genres

  def slug
  	x = self.username
  	x = x.downcase.gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = Show.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end
