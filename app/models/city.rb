class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings


  def city_openings(checkin, checkout)
  	self.neighborhoods.collect do |neighborhood|
  		neighborhood.neighborhood_openings(checkin, checkout)
  	end.flatten
  end

  def reservations_count
    listings.joins(:reservations).count
  end

  def listing_count
    listing.count
  end

  def self.highest_ratio_res_to_listings
    #self.joins(:listings).max_by {|city| city.reservations.count/city.listings.count.to_f}
    self.joins(:listings).max_by {|city| city.reservations_count/city.listings.count.to_f}
  end

  def self.most_res
    highest_city = ""
    count = 0
    self.all.each do |city|
      if city.reservations.count > count
        count = city.reservations.count
        highest_city = city
      end
    end
    highest_city
  end
end

