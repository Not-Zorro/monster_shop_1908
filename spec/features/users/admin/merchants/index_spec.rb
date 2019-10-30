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
    cat_the_merchant = Merchant.create!(name: "Cat's Shop", address: '456 Cat Rd.', city: 'Cat City', state: 'VA', zip: 23137)

    pull_toy = cat_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = cat_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
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

    within "#merchant-#{cat_the_merchant.id}" do
      click_button 'Disable'
      expect(page).to have_button 'Enable'
    end

    expect(page).to have_content("#{cat_the_merchant.name} has been disabled")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/items"
    expect(page).to_not have_content(pull_toy.name)
    expect(page).to_not have_content(dog_bone.name)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/merchants'

    within "#merchant-#{cat_the_merchant.id}" do
      click_button 'Enable'
      expect(page).to have_button 'Disable'
    end

    expect(page).to have_content("#{cat_the_merchant.name} has been enabled")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit "/items"
    expect(page).to have_content(pull_toy.name)
    expect(page).to have_content(dog_bone.name)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/merchants'

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

  it 'I can see a link to create a new merchant' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    visit '/merchants'

    expect(page).to have_link("New Merchant")

    click_on "New Merchant"

    expect(current_path).to eq("/admin/merchants/new")
  end

end
