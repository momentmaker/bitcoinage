class PricePoint < ActiveRecord::Base
  ONE_DAY_UNIX = 86400000

  def self.data(date=nil)
    data = get_json(date)
    chart_array = []
    data["bpi"].each do |date, price|
      chart_array << [unix_time(date), price]
    end
    chart_array
  end

  def self.up_to_date?
    last_date_db = PricePoint.last.date
    previous_date = unix_time(PricePoint.get_previous_date)
    last_date_db < previous_date ? false : true
  end

  def self.update_prices
    if !up_to_date?
      start_date = PricePoint.last.date + ONE_DAY_UNIX
      PricePoint.data(start_date).each do |e|
        PricePoint.create(date: e[0], price: e[1])
      end
    end
  end

  def self.get_previous_date
    date = Time.at(Time.now.to_i - 86400).to_s
    date[0..9]
  end

  def self.get_todays_date
    date = Time.at(Time.now.to_i).to_s
    date[0..9]
  end

  def self.get_json(date=nil)
    start_date = string_time(date) || "2011-01-01"
    end_date = get_previous_date
    JSON.load(open("https://api.coindesk.com/v1/bpi/historical/close.json?start=#{start_date}&end=#{end_date}"))
  end

  def self.unix_time(date)
    date_int = date.split("-").map(&:to_i)
    date_convert = Date.new(date_int[0], date_int[1], date_int[2]).to_time.to_i
    date_convert = date_convert.to_s + "000"
    date_int = date_convert.to_i
  end

  def self.string_time(unix)
    date = Time.at(unix.to_s[0..9].to_i)
    date.to_s[0..9]
  end
end
