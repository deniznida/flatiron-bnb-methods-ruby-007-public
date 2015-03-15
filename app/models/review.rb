class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id

  validate :guest_checkout_out

  private
  def guest_checkout_out
  	if reservation && reservation.checkout > Date.today
  		errors.add(:review, "Submit your review after checkout.")
  	end
  end

end
