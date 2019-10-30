class UsersController < ApplicationController

  def new
  end

  def show
    render file: '/public/404' if current_user.nil?
  end

  def create
    new_user = User.create(user_params)
    if new_user.save
      session[:user_id] = new_user.id
      flash[:success] = "You are now registered and logged in."
      redirect_to '/profile'
    else
      flash.now[:error] = new_user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    user.update(user_update_params)
    if user.save
      flash[:success] = 'Your profile has been updated'
      redirect_to '/profile'
    else
      flash.now[:error] = user.errors.full_messages.to_sentence
      @user = user
      render :edit
    end
  end

  def edit_password
  end

  def update_password
    if password_blank(password_params)
      flash.now[:error] = "Password can't be blank"
      render :edit_password
    else
      current_user.update(password_params)
      if current_user.save
        flash[:success] = 'Your password has been changed.'
        redirect_to '/profile'
      else
        flash.now[:error] = current_user.errors.full_messages.first
        render :edit_password
      end
    end
  end

  private
    def user_params
      params.permit(:name,:address,:city,:state,:zip,:email,:password,:password_confirmation)
    end

    def user_update_params
      params.permit(:name,:address,:city,:state,:zip,:email)
    end

    def password_params
      params.permit(:password,:password_confirmation)
    end

    def password_blank(password_params)
      return true if password_params[:password].length == 0
      false
    end
end
