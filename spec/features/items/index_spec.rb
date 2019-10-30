require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_leash = @brian.items.create(name: "Dog Leash", description: "It's a dog leash!", price: 15, inventory: 50)
      @kong_toy = @brian.items.create(name: "Kong Toy", description: "Konggggggg!", price: 30, inventory: 30)
      @dog_booties = @brian.items.create(name: "Dog Booties", description: "You can walk in the snow!", price: 100, inventory: 20)
      @dog_carrier = @brian.items.create(name: "Canine Sports Sack", description: "You can hike with your dog in a sack!", price: 150, inventory: 22)
      @dog_beard_butter = @brian.items.create(name: "Dog Beard Butter", description: "The softest fur in barktown!", price: 20, inventory: 100)

      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @user = User.create( name: 'Bob J',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'user@user.com',
                          password: 'password')

      @merchant = User.create( name: 'Merchant Person',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'merchant@merchant.com',
                          password: 'password',
                          role: 2)

      @admin = User.create( name: 'Admin Person',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'admin@admin.com',
                          password: 'password',
                          role: 3)

      @order_1 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip, user_id: @user.id)
      @item_order_1 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 1)
      @item_order_2 = @order_1.item_orders.create!(item: @dog_leash, price: @dog_leash.price, quantity: 2)
      @item_order_3 = @order_1.item_orders.create!(item: @dog_booties, price: @dog_booties.price, quantity: 3)
      @item_order_4 = @order_1.item_orders.create!(item: @dog_carrier, price: @dog_carrier.price, quantity: 4)
      @item_order_5 = @order_1.item_orders.create!(item: @dog_beard_butter, price: @dog_beard_butter.price, quantity: 5)
      @item_order_6 = @order_1.item_orders.create!(item: @kong_toy, price: @kong_toy.price, quantity: 6)

    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it 'can show active items to all users and images are now links' do

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password

      click_button 'Login'

      visit '/items'

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)
      expect(page).to_not have_content(@dog_bone.name)

      find(".image-link-#{@tire.id}").click


      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "as a merchant I can see all items" do
      visit '/login'

      fill_in :email, with: @merchant.email
      fill_in :password, with: @merchant.password

      click_button 'Login'

      visit '/items'

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@dog_bone.name)

      find(".image-link-#{@tire.id}").click

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "as an admin I can see all items" do
      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password

      click_button 'Login'

      visit '/items'

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@dog_bone.name)

      find(".image-link-#{@tire.id}").click

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "shows item statistics" do
      visit '/items'

      within '#item-stats-most-popular' do
        expect(page).to have_content("Five Most Popular Items")
        expect(page).to have_content(@dog_leash.name)
        expect(page).to have_content(@kong_toy.name)
        expect(page).to have_content(@dog_booties.name)
        expect(page).to have_content(@dog_beard_butter.name)
        expect(page).to have_content(@dog_carrier.name)

        expect(page).to_not have_content(@pull_toy.name)
      end

      within '#item-stats-least-popular' do
        expect(page).to have_content("Five Least Popular Items")
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@dog_leash.name)
        expect(page).to have_content(@dog_booties.name)
        expect(page).to have_content(@dog_beard_butter.name)
        expect(page).to have_content(@dog_carrier.name)

        expect(page).to_not have_content(@kong_toy.name)
      end
    end
  end
end