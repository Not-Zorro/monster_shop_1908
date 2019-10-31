class Profile::ReviewsController<ApplicationController
  before_action :require_user

  def require_user
    render file: '/public/404' unless current_user
  end

  def new
    @item = Item.find(params[:item_id])
  end

  def create
    if field_empty?
      item = Item.find(params[:item_id])
      flash[:error] = "Please fill in all fields in order to create a review."
      redirect_to "/items/#{item.id}/profile/reviews/new"
    else
      @item = Item.find(params[:item_id])
      review = @item.reviews.create(review_params)
      if review.save
        flash[:success] = "Review successfully created"
        redirect_to "/items/#{@item.id}"
      else
        flash[:error] = "Rating must be between 1 and 5"
        render :new
      end
    end
  end

  private

  def review_params
    params.permit(:title,:content,:rating).merge(:user_id => current_user.id)
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end


end
