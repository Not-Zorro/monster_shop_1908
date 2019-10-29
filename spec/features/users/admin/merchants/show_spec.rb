require 'rails_helper'

describe 'As an Admin on the /merchants show' do
  before(:each) do
    @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)

    pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )


    @order = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip, user_id: user.id)

    item_order_1 = @order.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)

    item_order_2 = @order.item_orders.create!(item: dog_bone, price: dog_bone.price, quantity: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it 'can display a merchant dashboard for admin users' do
    visit '/merchants'

    within "#merchant-#{@chester_the_merchant.id}" do
      click_link "Chester's Shop"
    end

    expect(current_path).to eq("/admin/merchants/#{@chester_the_merchant.id}")
    within '.employer-info' do
      expect(page).to have_content(@chester_the_merchant.name)
      expect(page).to have_content(@chester_the_merchant.address)
      expect(page).to have_content(@chester_the_merchant.city)
      expect(page).to have_content(@chester_the_merchant.state)
      expect(page).to have_content(@chester_the_merchant.zip)
    end
  end

  it 'shows details for pending orders' do
    visit "/admin/merchants/#{@chester_the_merchant.id}"
    within '.pending-orders' do
      expect(page).to have_link("Order #: #{@order.id}")
      expect(page).to have_content(@order.created_date)
      expect(page).to have_content(@order.item_count_for_merchant(@chester_the_merchant.id))
      expect(page).to have_content(@order.grand_total_for_merchant(@chester_the_merchant.id))
    end
  end
end
