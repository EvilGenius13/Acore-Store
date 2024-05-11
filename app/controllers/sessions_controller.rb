class SessionsController < ApplicationController
  def new
  end

  def create
    username = params[:session][:username]
    password = params[:session][:password]
    azeroth_user = AzerothUser.find_by(username: username)

    if azeroth_user && authenticate_user(username, password, azeroth_user.salt, azeroth_user.verifier)
      user = User.find_or_initialize_by(username: username)
      user.save(validate: false)  # Need to skip validation
      
      session[:username] = username  # Store username in session
      redirect_to dashboard_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid username or password"
      render :new
    end
  end

  def destroy
    session.delete(:username)  # Clear the username from session
    redirect_to login_path, notice: "Logged out"
  end

  private

  def authenticate_user(username, password, stored_salt, stored_verifier)
    RegistrationService.new.verify_password(username, password, stored_salt, stored_verifier)
  end
end
