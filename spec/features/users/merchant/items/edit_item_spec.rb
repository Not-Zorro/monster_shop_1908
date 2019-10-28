require 'rails_helper'

describe 'as a merchant admin' do
  describe 'when i visit my items page' do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
      @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

      @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    end

    it 'has a link to edit an item' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      within "#item-#{@pull_toy.id}" do
        click_link 'Edit Item'
      end

      price = 24
      description = "You can pull more expensively."

      expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")

      fill_in :price, with: price
      fill_in :description, with: description

      click_button "Update Item"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@pull_toy.name} has been updated")

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(description)
        expect(page).to have_content(price)
        expect(page).to have_content(@pull_toy.inventory)
        expect(page).to have_content('Status: Active')
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it 'does not update an item if a field is nil and repopulates form' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      within "#item-#{@pull_toy.id}" do
        click_link 'Edit Item'
      end

      fill_in :price, with: nil

      click_button "Update Item"

      expect(page).to have_content("Price can't be blank")

      expect(find_field('Name').value).to eq "Pull Toy"
      expect(find_field('Price').value).to eq '$10.00'
      expect(find_field('Description').value).to eq "Great pull toy!"
      expect(find_field('Image').value).to eq("http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg")
      expect(find_field('Inventory').value).to eq '32'
    end

    it 'I can see the prepopulated fields of that item' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      within "#item-#{@pull_toy.id}" do
        click_link 'Edit Item'
      end

      expect(page).to have_link("Pull Toy")
      expect(find_field('Name').value).to eq "Pull Toy"
      expect(find_field('Price').value).to eq '$10.00'
      expect(find_field('Description').value).to eq "Great pull toy!"
      expect(find_field('Image').value).to eq("http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg")
      expect(find_field('Inventory').value).to eq '32'
    end
  end
end
