class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Signed in as #{user.name}"
      redirect_role
    else
      flash.now[:error] = "Sorry your credentials are bad."
      render :new
    end
  end

  def destroy
    session.clear
    flash[:success] = 'You have logged out.'
    redirect_to '/'
  end

  private

    def redirect_role
      if current_admin?
        redirect_to '/admin'
      elsif current_merchant_employee? || current_merchant_admin?
        redirect_to '/merchant'
      else
        redirect_to '/profile'
      end
    end
end
