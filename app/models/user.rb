class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :email, :password_digest

  validates :email, uniqueness: true
  validates :password, confirmation: { case_sensitive: true }

  has_many :orders
  has_many :reviews
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: [:default, :merchant_employee, :merchant_admin, :admin]

  def has_orders?
    orders.count > 0
  end

  def created_date
    created_at.strftime('%B %d, %Y')
  end
end
