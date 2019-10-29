class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: [:packaged, :pending, :shipped, :cancelled, :fulfilled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def created_date
    created_at.strftime('%B %d, %Y')
  end

  def updated_date
    updated_at.strftime('%B %d, %Y')
  end

  def item_count
    item_orders.sum(:quantity)
  end

  def unfulfilled_item_orders
    item_orders.each do |item_order|
      item_order.update(status: 'unfulfilled')
    end
  end

  def items_of_merchant(merchant_id)
    items.where(merchant_id: merchant_id)
  end

  def item_count_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum(:quantity)
  end

  def grand_total_for_merchant(merchant_id)
    item_orders.joins(:item).where(items: {merchant_id: merchant_id}).sum('item_orders.quantity * item_orders.price')
  end

  def all_items_fulfilled?
    item_orders.where(status: 'pending').empty?
  end

  def self.dashboard_sort
    order(:status)
  end
end
