class Transaction < ActiveRecord::Base
  belongs_to :user

  validates :satoshi, presence: true, numericality: { greater_than: 0 }
  validates :bitcoin, presence: true, numericality: { greater_than: 0 }
  validates :price_cent, presence: true, numericality: { greater_than: 0 }
  validates :price_dollar, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :fees_percentage, presence: true, numericality: { greater_than: 0 }

  attr_accessor :type

  def bitcoin
    satoshi.to_f / 100_000_000 if satoshi
  end

  def bitcoin=(value)
    self.satoshi = value.to_f * 100_000_000
  end

  # before_save do
  #   if type == "DEBIT"
  #     self.amount = -absolute_amount
  #   end
  # end

  # def convert_satoshi
  #   satoshi.to_f / 100000000 if satoshi
  # end
  #
  # def convert_satoshi=(bitcoin)
  #   self.satoshi = bitcoin.to_f * 100000000
  # end

  def price_dollar
    price_cent.to_f / 100 if price_cent
  end

  def price_dollar=(value)
    self.price_cent = value.to_f * 100
  end

  def fees
    fees_percentage.to_f / 100 if fees_percentage
  end

  def fees=(value)
    self.fees_percentage = value[0..-1].to_f * 100
  end

  def total_spent
    fees_percentage = 1 + self.fees / 100
    (self.price_cent * self.satoshi * fees_percentage) / 10_000_000_000.to_f
  end
end
