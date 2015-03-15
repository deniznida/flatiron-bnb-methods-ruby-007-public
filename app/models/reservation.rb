class Reservation < ActiveRecord::Base
 	belongs_to :listing
 	belongs_to :guest, :class_name => "User"
 	has_one :review
 

 	validate :valid_checkin_and_checkout, :validate_on_listing, :validate_checkin_checkout_before_reservation
 	validates_presence_of :checkin, :checkout

 	validate :validate_on_listing

 	def reservation_range
 		(self.checkin...self.checkout)
 	end

 	def duration
   	self.checkout - self.checkin
 	end

 	def total_price
   	self.listing.price * self.duration
 	end

 	private
   	def valid_checkin_and_checkout
     	if self.checkin && self.checkout
       	if self.checkin >= self.checkout
         	errors.add(:checkin, "Checkin date must be before checkout date.")
       	end
     	end
   	end

   	def validate_on_listing
     	if self.guest_id == listing.host_id
       	errors.add(:guest_id, "You live here.")
     	end
   	end

   	def validate_checkin_checkout_before_reservation 
     	self.listing.reservations.each do |reservation|
       	if (reservation.checkin...reservation.checkout).include?(self.checkin) || (reservation.checkin...reservation.checkout).include?(self.checkout)
         	errors.add(:listing, "Your dates don't work.")
       	end
     	end
   	end
end