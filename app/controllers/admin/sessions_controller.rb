module Admin
  class SessionsController < ApplicationController
    def new
    end

    def create
      username = params[:session][:username]
      password = params[:session][:password]

      if username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
        puts "we hit"
        session[:admin_username] = username # Store admin username in session
        redirect_to admin_settings_path, notice: 'Admin logged in successfully.'
      else
        flash.now[:alert] = 'Invalid username or password'
        render :new
      end
    end

    def destroy
      sessions.delete[:admin_username]
      redirect_to admin_login_path, notice: 'Admin logged out.'
    end
  end
end