class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings



  def neighborhood_openings(start_date, end_date)
    self.listings.select do |listing|
      listing.reservations.each do |reservation|
				listing unless reservation.reservation_range.overlaps?(start_date...end_date)
      end
   	end
 	end


 	def self.highest_ratio_res_to_listings
  	joins(:listings).max_by {|neighborhood| neighborhood.reservations.count/neighborhood.listings.count.to_f}
 	end

	def self.most_res
	  highest_neighborhood = ""
	  count = 0
	  self.all.each do |neighborhood|
	    if neighborhood.reservations.count > count
	      count = neighborhood.reservations.count
	      highest_neighborhood = neighborhood
	    end
	  end
	  highest_neighborhood
	end
end
