class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: :true
  validates :listing_type, presence: :true
  validates :title, presence: :true
  validates :description, presence: :true
  validates :price, presence: :true
  validates :neighborhood_id, presence: :true
  
  #validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_create :set_host
  before_destroy :unset_host

  # def sum_ratings
  #   self.reviews.collect {|review| review.rating.to_f }.inject{|sum, num| sum += num }
  # end

  def average_rating
    #self.sum_ratings / self.reviews.count
    self.reviews.average(:rating)
  end


  def set_host
    self.host.host = true #first host is attr, second host is column
    self.host.save
  end

  def unset_host
    if host.listings.size == 1
      self.host.host = false
      self.host.save
    end
  end

end
