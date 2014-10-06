class PricePoint < ActiveRecord::Base
  def self.data
    data = get_json
    chart_array = []

    data["bpi"].each do |date, price|
      chart_array << [convert_time(date), price]
    end

    chart_array
  end

  def self.get_current_date
    date = Time.at(Time.now.to_i - 86400).to_s
    date[0..9]
  end

  def self.get_json
    date = get_current_date
    JSON.load(open("https://api.coindesk.com/v1/bpi/historical/close.json?start=2011-01-01&end=#{date}"))
  end

  def self.convert_time(date)
    date_int = date.split("-").map(&:to_i)
    date_convert = Date.new(date_int[0], date_int[1], date_int[2]).to_time.to_i
    date_convert = date_convert.to_s + "000"
    date_int = date_convert.to_i
  end
end
