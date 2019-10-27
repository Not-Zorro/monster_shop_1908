require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @merchant_employee = User.create(merchant_id: @brian.id, name: 'Merchant User', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchant@user.com', password: 'password', role: 1 )
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      @order_2 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, created_at: 'Fri, 18 Oct 2019 21:56:35 UTC +00:00', updated_at: 'Fri, 25 Oct 2019 21:56:35 UTC +00:00')
      @order_3 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, created_at: 'Fri, 18 Oct 2019 21:56:35 UTC +00:00', updated_at: 'Fri, 25 Oct 2019 21:56:35 UTC +00:00')

      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @item_order_3 = @order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_4 = @order_3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'defaults status to pending' do
      expect(@order_1.status).to eq('pending')
    end

    it 'returns a created date in FullMonth Day, Year' do
      expect(@order_2.created_date).to eq('October 18, 2019')
    end

    it 'returns an updated date in FullMonth Day, Year' do
      expect(@order_2.updated_date).to eq('October 25, 2019')
    end

    it 'returns the total quantity of items in an order for a specific merchant' do
      expect(@order_1.item_count_for_merchant(@merchant_employee.merchant_id)).to eq(3)
    end

    it 'returns the grand total of item prices in an order for a merchant' do
      expect(@order_1.grand_total_for_merchant(@merchant_employee.merchant_id)).to eq(30)
    end

    it "when cancelled all it's item orders status updates to unfulfilled" do
      expect(@item_order_1.status).to eq('pending')
      expect(@item_order_2.status).to eq('pending')
      @order_1.unfulfilled_item_orders
      expect(@item_order_1.status).to eq('unfulfilled')
      expect(@item_order_2.status).to eq('unfulfilled')
    end

    it 'returns the items of an order for the current_user.merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)

      expected = [@pull_toy]

      expect(@order_3.items_of_merchant(@merchant_employee.merchant_id)).to eq(expected)
    end

    it 'returns true if all item_orders are fulfilled' do
      expect(@order_1.all_items_fulfilled?).to be_falsy

      @order_1.item_orders.each do |item_order|
        item_order.update(status: 'fulfilled')
      end 

      expect(@order_1.all_items_fulfilled?).to be_truthy
    end
  end
end
