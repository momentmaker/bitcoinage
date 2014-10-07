class Transaction < ActiveRecord::Base
  belongs_to :user

  validates :satoshi, presence: true, numericality: { greater_than: 0 }
  validates :convert_satoshi, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :convert_currency, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :fees, presence: true, numericality: { greater_than: 0 }

  def convert_satoshi
    satoshi.to_f / 100000000 if satoshi
  end

  def convert_satoshi=(bitcoin)
    self.satoshi = bitcoin.to_f * 100000000
  end

  def convert_currency
    price.to_f / 100 if price
  end

  def convert_currency=(dollar)
    self.price = dollar.to_f * 100
  end

  def convert_fees
    fees[0..-1].to_f * 100 if fees
  end

  def convert_fees=(percent)
    self.fees = percent[0..-1].to_f * 100
  end
end
