class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user_signed_in?, :current_user, :same_user?, :authenticate!, :get_chart_data

  protected

  ONE_DAY_UNIX = 86400000

  def user_signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def set_current_user(user)
    @current_user = user
  end

  def same_user?(user)
    user.user_id == current_user.id
  end

  def authenticate!
    unless user_signed_in?
      flash[:notice] = 'You need to sign in if you want to do that!'

      redirect_to root_path
    end
  end

  def all_chart_data
    data = []
    PricePoint.all.each do |e|
      data << [e.date, e.price]
    end
    data
  end

  def select_chart_data(transaction)
    data = []
    start_date = PricePoint.unix_time(transaction.date.to_s)
    end_date = PricePoint.last.date

    before_trans_date = start_date - ONE_DAY_UNIX * 30

    PricePoint.where('date >= ? AND date <= ?', before_trans_date, end_date).each do |e|
      data << [e.date, e.price]
    end
    data
  end
end
