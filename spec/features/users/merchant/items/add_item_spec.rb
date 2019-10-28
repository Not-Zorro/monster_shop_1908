require 'rails_helper'

describe 'as a merchant admin' do
  describe 'when i visit my items page' do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
      @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

    end

    it 'has a link to add an item' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@chester_the_merchant.name)
      expect(current_path).to eq("/merchant/items/new")
      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      item = Item.last
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{name} has been added")

      within "#item-#{item.id}" do
        expect(page).to have_content(item.name)
        expect(page).to have_content(item.description)
        expect(page).to have_content(item.price)
        expect(page).to have_content(item.inventory)
        expect(page).to have_content('Status: Active')
        expect(page).to have_css("img[src*='#{item.image}']")
      end
    end

    it 'has a default image for items made without a specfic image url' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@chester_the_merchant.name)
      expect(current_path).to eq("/merchant/items/new")
      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :inventory, with: inventory

      click_button "Create Item"

      item = Item.last
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{name} has been added")

      within "#item-#{item.id}" do
        expect(page).to have_content(item.name)
        expect(page).to have_content(item.description)
        expect(page).to have_content(item.price)
        expect(page).to have_content(item.inventory)
        expect(page).to have_content('Status: Active')
        expect(page).to have_css("img[src*='https://cdn2.mhpbooks.com/2018/07/cowboy-hat.png']")
      end
    end

    it 'does not add an item if required info is incomplete' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@chester_the_merchant.name)
      expect(current_path).to eq("/merchant/items/new")
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      expect(page).to have_content("Name can't be blank")
    end
  end
end
