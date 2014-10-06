class SessionsController < ApplicationController
  def new
    redirect_to "/auth/twitter"
  end

  def create
    user = User.find_or_create_from_omniauth(auth_hash)
    session[:user_id] = user.id
    set_current_user(user)
    flash[:notice] = "Successfully signed in as #{user.username}."

    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Signed out successfully."

    redirect_to root_path
  end


  def failure
    flash[:notice] = "Unable to sign in."

    redirect_to root_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
