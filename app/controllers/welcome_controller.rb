class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to transactions_path
    else
      render layout: "welcome"
    end
  end
end
