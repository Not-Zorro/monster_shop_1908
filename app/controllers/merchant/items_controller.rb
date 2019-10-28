class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def fulfill
    item = Item.find(params[:item_id])
    item_order = item.item_orders.find_by(order_id: params[:order_id])
    order = Order.find(params[:order_id])
    item_order.update(status: 'fulfilled')
    new_inventory = item.inventory - item_order.quantity
    item.update(inventory: new_inventory)
    order.update(status: 'packaged') if order.all_items_fulfilled?
    flash[:success] = "You have fulfilled #{item.name}."
    redirect_to "/merchant/orders/#{params[:order_id]}"
  end

  def deactivate
    item = Item.find(params[:id])
    item.update(active?: false)
    flash[:success] = "#{item.name} is no longer for sale"
    redirect_to '/merchant/items'
  end

end
