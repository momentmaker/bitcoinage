class Transaction < ActiveRecord::Base
  SATOSHI_BITCOIN_FACTOR = 100_000_000.0
  FEE_PERCENTAGES = ["0.1%", "0.2%", "0.25%", "0.3%", "0.5%", "0.75%", "1.0%", "1.25%", "1.5%", "2.0%"]
  TYPE = ["Buy", "Sell"]
  ONE_DAY_UNIX = 86400000

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
    else
      self.satoshi = -(self.satoshi) if self.satoshi < 0
    end
  end

  def find_type
    if satoshi != nil
      if satoshi > 0
        "Buy"
      elsif satoshi < 0
        "Sell"
      else
        nil
      end
    end
  end

  def buy?
    satoshi > 0
  end

  def bitcoin
    satoshi.to_f / SATOSHI_BITCOIN_FACTOR if satoshi
  end

  def bitcoin=(value)
    self.satoshi = value.to_f * SATOSHI_BITCOIN_FACTOR
  end

  def self.total_satoshi_buy
    where('satoshi > 0').sum(:satoshi)
  end

  def self.avg_satoshi_buy
    where('satoshi > 0').average(:satoshi)
  end

  def self.total_bitcoin_buy
    total_satoshi_buy / SATOSHI_BITCOIN_FACTOR
  end

  def self.avg_bitcoin_buy
    avg_satoshi_buy / SATOSHI_BITCOIN_FACTOR
  end

  def self.total_satoshi_sell
    where('satoshi < 0').sum(:satoshi)
  end

  def self.avg_satoshi_sell
    where('satoshi < 0').average(:satoshi)
  end

  def self.total_bitcoin_sell
    -total_satoshi_sell / SATOSHI_BITCOIN_FACTOR
  end

  def self.avg_bitcoin_sell
    -avg_satoshi_sell / SATOSHI_BITCOIN_FACTOR
  end

  def self.avg_cent_buy
    where('satoshi > 0').average(:price_cent)
  end

  def self.avg_dollar_buy
    avg_cent_buy / 100
  end

  def self.avg_cent_sell
    where('satoshi < 0').average(:price_cent)
  end

  def self.avg_dollar_sell
    avg_cent_sell / 100
  end

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

  def find_fee_percentage
    fee = fees_percentage.to_f / 100
    fee.to_s + "%"
  end

  def self.total_investment_buy
    buys = where('satoshi > 0')
    sum = 0
    buys.each do |buy|
      sum += buy.satoshi * buy.price_cent / 100 * (1 + buy.fees_percentage / 10000) / SATOSHI_BITCOIN_FACTOR
    end
    sum
  end

  def self.avg_investment_buy
    sum = total_investment_buy
    buys = where('satoshi > 0')
    sum / buys.count
  end

  def self.total_investment_sell
    sells = where('satoshi < 0')
    sum = 0
    sells.each do |sell|
      sum += sell.satoshi * sell.price_cent / 100 * (1 + sell.fees_percentage / 10000) / SATOSHI_BITCOIN_FACTOR
    end
    -sum
  end

  def self.avg_investment_sell
    -sum = total_investment_sell
    sells = where('satoshi < 0')
    sum / sells.count
  end

  def total_investment
    fees_percentage = 1 + self.fees / 100
    (self.price_cent / 100 * self.satoshi * fees_percentage) / SATOSHI_BITCOIN_FACTOR
  end

  def avg_price_per(days)
    points = []
    date_limit = PricePoint.unix_time(PricePoint.get_previous_date)
    trans_date = PricePoint.unix_time(self.date.to_s)
    end_date = trans_date + ONE_DAY_UNIX * days

    days = PricePoint.where('date > ? AND date <= ?', trans_date, end_date)
    price_sum = 0
    days.each do |day|
      price_sum += day.price
    end
    avg = price_sum / days.count
  end

  def within?(days)
    # date_limit = PricePoint.unix_time(PricePoint.get_previous_date)
    date_limit = PricePoint.last.date
    trans_date = PricePoint.unix_time(self.date.to_s)
    end_date = trans_date + ONE_DAY_UNIX * days

    if end_date > date_limit
      false
    else
      true
    end
  end

  def compare(days)
    (price_dollar - avg_price_per(days)).abs
  end

  def beat_avg?(days)
    if buy?
      price_dollar < avg_price_per(days) ? true : false
    else
      price_dollar > avg_price_per(days) ? true : false
    end
  end
end
