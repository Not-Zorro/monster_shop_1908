class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
  end

  def create
    item = current_user.merchant.items.create(item_params)
    if item.save
      flash[:success] = "#{item.name} has been added"
      redirect_to "/merchant/items"
    else
      flash.now[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def fulfill
    item = Item.find(params[:item_id])
    item_order = item.item_orders.find_by(order_id: params[:order_id])
    order = Order.find(params[:order_id])
    fufill_update(item_order, item, order)
    flash[:success] = "You have fulfilled #{item.name}."
    redirect_to "/merchant/orders/#{params[:order_id]}"
  end

  def deactivate
    item = Item.find(params[:id])
    item.update(active?: false)
    flash[:success] = "#{item.name} is no longer for sale"
    redirect_to '/merchant/items'
  end

  def activate
    item = Item.find(params[:id])
    item.update(active?: true)
    flash[:success] = "#{item.name} is for sale"
    redirect_to '/merchant/items'
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "#{item.name} has been deleted"
    redirect_to '/merchant/items'
  end

  private

    def fufill_update(item_order, item, order)
      item_order.update(status: 'fulfilled')
      new_inventory = item.inventory - item_order.quantity
      item.update(inventory: new_inventory)
      order.update(status: 'packaged') if order.all_items_fulfilled?
    end

    def item_params
      if params[:image] == ''
        params.permit(:name,:description,:price,:inventory)
      else
        params.permit(:name,:description,:price,:inventory, :image)
      end
    end

end
