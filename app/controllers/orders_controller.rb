class OrdersController <ApplicationController

  def new
    if current_user.nil?
      flash[:error] = 'Please login or register to continue'
      redirect_to '/cart'
    end
  end

end
