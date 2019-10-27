require 'rails_helper'

describe 'On an order show page linked from a merchant dashboard' do
  describe 'as a merchant employee or merchant admin' do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
      merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )

      @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)


      @order = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id)
      @item_order_1 = @order.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
      @item_order_2 = @order.item_orders.create!(item: @dog_bone, price: @dog_bone.price, quantity: 1)
      @item_order_3 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)

      @users = [@merchant_employee, merchant_admin]
    end

    it 'has order information' do
      @users.each do |user|
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        visit '/merchant'

        within ".pending-orders" do
          click_link("Order #: #{@order.id}")
        end

        expect(current_path).to eq("/merchant/orders/#{@order.id}")

        within '.customer-info' do
          expect(page).to have_content(@user.name)
          expect(page).to have_content(@user.address)
          expect(page).to have_content(@user.city)
          expect(page).to have_content(@user.state)
          expect(page).to have_content(@user.zip)
        end

        within "#item-#{@pull_toy.id}" do
          expect(page).to have_link(@pull_toy.name)
          expect(page).to have_css("img[src*='#{@pull_toy.image}']")
          expect(page).to have_content(@pull_toy.price)
          expect(page).to have_content(@item_order_1.quantity)
        end

        within "#item-#{@dog_bone.id}" do
          expect(page).to have_link(@dog_bone.name)
          expect(page).to have_css("img[src*='#{@dog_bone.image}']")
          expect(page).to have_content(@dog_bone.price)
          expect(page).to have_content(@item_order_2.quantity)
        end

        expect(page).to_not have_css("#item-#{@tire.id}")
      end
    end

    it "it can fulfill a partial order" do
      # only happy paths due to user story 33. Ask Mike about sad path / user story conflict.
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
      visit '/merchant'

      within ".pending-orders" do
        click_link("Order #: #{@order.id}")
      end

      expect(current_path).to eq("/merchant/orders/#{@order.id}")

      within("#item-#{@pull_toy.id}") do
        click_link 'fulfill'
      end

      expect(current_path).to eq("/merchant/orders/#{@order.id}")

      within("#item-#{@pull_toy.id}") do
        expect(page).to have_content('fulfilled')
      end

      expect(page).to have_content("You have fulfilled #{@pull_toy.name}.")

      visit "/items/#{@pull_toy.id}"

      expect(page).to have_content('Inventory: 30')
    end
  end
end