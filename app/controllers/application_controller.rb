class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user_signed_in?, :current_user, :same_user?, :authenticate!, :get_chart_data

  protected
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

  def get_chart_data
    data = []
    PricePoint.all.each do |e|
      data << [e.date, e.price]
    end
    data
  end
end
