class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if params[:user][:password] != params[:user][:verify_password]
      @user.errors.add(:password, 'does not match the verification password.')
      render :new and return
    end

    puts @user.valid?
    if @user.valid?
      puts "user valid"
      registration_service = RegistrationService.new
      result = registration_service.register_user(params[:user])
      puts "Result of registration", result
      if result[:status] == :success
        @user.save
        redirect_to login_path, notice: 'User was successfully created.'
      else
        flash.now[:alert] = result[:error]
        render :new
      end
    else
      render :new
    end
  end

  def login
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :verify_password)
  end
end
