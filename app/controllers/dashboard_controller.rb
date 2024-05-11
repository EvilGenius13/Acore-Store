class DashboardController < ApplicationController
  before_action :set_user

  def index
  end

  private

  def set_user
    @user = AzerothUser.find_by(username: session[:username])
    redirect_to login_path, alert: "You must be logged in to access the dashboard." unless @user
  end
end
