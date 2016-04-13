class Show < ActiveRecord::Base
  belongs_to :user
  has_many :actor_shows
  has_many :actors, :through => :actor_shows
  has_many :show_genres
  has_many :genres, :through => :show_genres
  validates :title, presence: true, length: { minimum: 2 }
  validates :year, presence: true, length: { minimum: 4 }

  def slug
  	x = self.title
  	x = x.downcase.gsub(/[^a-z ]/,"").gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = Show.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end
