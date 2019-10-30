require 'rails_helper'

RSpec.describe "As a merchant_admin" do
  describe "After visiting a merchants show page and clicking on updating that merchant" do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
      @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
      @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
    end

    it 'I can see prepopulated info on that user in the edit form' do
      visit "/merchant/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      expect(page).to have_link(@bike_shop.name)
      expect(find_field('Name').value).to eq "Meg's Bike Shop"
      expect(find_field('Address').value).to eq '123 Bike Rd.'
      expect(find_field('City').value).to eq 'Denver'
      expect(find_field('State').value).to eq 'CO'
      expect(find_field('Zip').value).to eq "80203"
    end

    it 'I can edit merchant info by filling in the form and clicking submit' do
      visit "/merchant/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: "Brian's Super Cool Bike Shop"
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: "Denver"
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}")
      expect(page).to have_content("Brian's Super Cool Bike Shop")
      expect(page).to have_content("1234 New Bike Rd.\nDenver, CO 80204")
    end

    it 'I see a flash message if i dont fully complete form' do
      visit "/merchant/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: ""
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: ""
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(page).to have_content("Name can't be blank and City can't be blank")
      expect(page).to have_button("Update Merchant")
    end
  end
end
