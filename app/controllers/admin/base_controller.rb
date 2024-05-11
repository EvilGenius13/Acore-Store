module Admin
  class BaseController < ApplicationController
    before_action :authenticate_admin

    private

    def authenticate_admin
      redirect_to admin_login_path, alert: 'Please login to continue.' unless session[:admin_username]
    end
  end
end