class ReviewsController<ApplicationController



  def destroy
    review = Review.find(params[:id])
    item = review.item
    review.destroy
    redirect_to "/items/#{item.id}"
  end

  private

  def review_params
    params.permit(:title,:content,:rating)
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end
end
