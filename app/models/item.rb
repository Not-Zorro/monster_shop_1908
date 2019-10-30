class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def quantity_ordered(order_id)
    item_orders.find_by(order_id: order_id).quantity
  end

  def fulfilled?(order_id)
    item_orders.find_by(order_id: order_id).status == 'fulfilled'
  end

  def can_fulfill?(order_id)
    inventory >= quantity_ordered(order_id)
  end

  def status
    if active?
      'Active'
    else
      'Inactive'
    end
  end

  def self.item_stats(order)
    item_id_hash = joins(:item_orders).order("sum_item_orders_quantity #{order}").limit(5).group("item_orders.item_id").sum("item_orders.quantity")

    item_name_hash = Hash.new
    item_id_hash.each do |id, quantity|
      item_name_hash[Item.find(id)] = quantity
    end
    item_name_hash
  end

end
