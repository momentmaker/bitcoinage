class Transaction < ActiveRecord::Base
  SATOSHI_BITCOIN_FACTOR = 100_000_000.0

  belongs_to :user

  validates :type, presence: true
  validates :satoshi, presence: true, numericality: true
  validates :bitcoin, presence: true, numericality: true
  validates :price_cent, presence: true, numericality: { greater_than: 0 }
  validates :price_dollar, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true
  validates :fees_percentage, presence: true, numericality: { greater_than: 0 }

  attr_accessor :type

  before_save do
    if type == "Sell"
      self.satoshi = -(self.satoshi) if self.satoshi > 0
    end
  end

  def bitcoin
    satoshi.to_f / SATOSHI_BITCOIN_FACTOR if satoshi
  end

  def bitcoin=(value)
    self.satoshi = value.to_f * SATOSHI_BITCOIN_FACTOR
  end

  def self.total_satoshi
    sum(:satoshi)
  end

  def self.avg_satoshi
    average(:satoshi)
  end

  def self.total_satoshi_buy
    where('satoshi > ?', 0.0).sum(:satoshi)
  end

  def self.avg_satoshi_buy
    average(:satoshi).where('satoshi > ?', 0.0)
  end

  def self.total_bitcoin
    total_satoshi / SATOSHI_BITCOIN_FACTOR
  end

  def self.avg_bitcoin
    avg_satoshi / SATOSHI_BITCOIN_FACTOR
  end

  def self.total_bitcoin_buy
    total_satoshi_buy / SATOSHI_BITCOIN_FACTOR
  end

  def self.avg_bitcoin_buy
    avg_satoshi_buy / SATOSHI_BITCOIN_FACTOR
  end

  def price_dollar
    price_cent.to_f / 100 if price_cent
  end

  def price_dollar=(value)
    self.price_cent = value.to_f * 100
  end

  def self.total_cent
    sum(:price_cent)
  end

  def self.avg_cent
    average(:price_cent)
  end

  def self.total_dollar
    total_cent / 100
  end

  def self.avg_dollar
    avg_cent / 100
  end

  def fees
    fees_percentage.to_f / 100 if fees_percentage
  end

  def fees=(value)
    self.fees_percentage = value[0..-1].to_f * 100
  end

  def total_investment
    fees_percentage = 1 + self.fees / 100
    (self.price_cent * self.satoshi * fees_percentage) / SATOSHI_BITCOIN_FACTOR
  end
end
