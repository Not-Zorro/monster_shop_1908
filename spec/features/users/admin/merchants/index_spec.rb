require 'rails_helper'

describe 'As an Admin on the /merchants index' do
  before(:each) do
    @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)


    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)
  end

  it 'I see all the merchants with an option to disable/enable the merchant' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/merchants'

    within "#merchant-#{@chester_the_merchant.id}" do
      expect(page).to have_link("Chester's Shop")
      expect(page).to have_content("Richmond, VA")
      expect(page).to have_button('Disable')
    end

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to have_link("Meg's Bike Shop")
      expect(page).to have_content("Denver, CO")
      expect(page).to have_button('Disable')
    end

    within "#merchant-#{@chester_the_merchant.id}" do
      click_button 'Disable'
      expect(page).to have_button 'Enable'
    end

    expect(page).to have_content("#{@chester_the_merchant.name} has been disabled")

    within "#merchant-#{@chester_the_merchant.id}" do
      click_button 'Enable'
      expect(page).to have_button 'Disable'
    end
    expect(page).to have_content("#{@chester_the_merchant.name} has been enabled")
    within "#merchant-#{@chester_the_merchant.id}" do
      click_link("Chester's Shop")
    end

    expect(current_path).to eq("/admin/merchants/#{@chester_the_merchant.id}")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit '/merchants'

    within "#merchant-#{@chester_the_merchant.id}" do
      expect(page).to_not have_button('Disable')
    end

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to_not have_button('Disable')
    end
  end
end
