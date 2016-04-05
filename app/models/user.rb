class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
  	x = self.username
  	x = x.downcase.gsub(" ","-")
    x
  end

  def self.find_by_slug(slug)
  	x = User.all.find do |a|
      a.slug == slug
  	  end
    x
  end

end
