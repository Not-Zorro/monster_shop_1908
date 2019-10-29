require 'rails_helper'

describe 'As an Admin on my admin dashboard' do
  before(:each) do
    @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    # @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    # merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )

    @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)

    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)


    @order = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id)
    @item_order_1 = @order.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
    @item_order_2 = @order.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 1)
    @item_order_3 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)

    @order_2 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id, status: 'cancelled')
    @item_order_4 = @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 5, status: 'cancelled')

    @order_3 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id, status: 'shipped')
    @item_order_5 = @order_3.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 10, status: 'shipped')

    @order_4 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id, status: 'packaged')
    @item_order_6 = @order_4.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 8, status: 'packaged')

  end

  it 'can see all orders in the system' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/admin'

    within "#order-#{@order.id}" do
      expect(page).to have_link(@order.name)
      expect(page).to have_content("Order #: #{@order.id}")
      expect(page).to have_content("Order Date: #{@order.created_date}")

      expect(page).to have_content('pending')
    end
    within "#order-#{@order_2.id}" do
      expect(page).to have_link(@order_2.name)
      expect(page).to have_content("Order #: #{@order_2.id}")
      expect(page).to have_content("Order Date: #{@order_2.created_date}")

      expect(page).to have_content('cancelled')
    end
    within "#order-#{@order_3.id}" do
      expect(page).to have_link(@order_3.name)
      expect(page).to have_content("Order #: #{@order_3.id}")
      expect(page).to have_content("Order Date: #{@order_3.created_date}")

      expect(page).to have_content('shipped')
    end
    within "#order-#{@order_4.id}" do
      expect(page).to have_link(@order_4.name)
      expect(page).to have_content("Order #: #{@order_4.id}")
      expect(page).to have_content("Order Date: #{@order_4.created_date}")

      expect(page).to have_content('packaged')
    end
  end

  it 'has a button to ship an order next to packaged orders' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/admin'

    within "#order-#{@order_3.id}" do
      expect(page).to_not have_button("Ship Order")
    end

    within "#order-#{@order_4.id}" do
      expect(page).to have_button("Ship Order")
      click_button("Ship Order")
    end

    within "#order-#{@order_4.id}" do
      expect(page).to have_content('shipped')
      expect(page).to_not have_button("Ship Order")
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/profile/orders/#{@order_4.id}"

    expect(page).to have_content('Shipped')
    expect(page).to_not have_button "Cancel Order"

  end
end
