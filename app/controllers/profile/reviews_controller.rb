class Profile::ReviewsController<ApplicationController
  before_action :require_user

  def require_user
    render file: '/public/404' unless current_user
  end

  def new
    @item = Item.find(params[:item_id])
  end

end
