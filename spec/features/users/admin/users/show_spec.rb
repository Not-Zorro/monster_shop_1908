require 'rails_helper'

describe "Admin users index page" do
  before(:each) do

    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)
    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @merchant_employee = User.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    @merchant_admin = User.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
  end

  it 'can display a users show page without edit link' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit '/admin/users'

    within "#user-#{@user.id}" do
      click_link(@user.name)
    end

    expect(current_path).to eq("/admin/users/#{@user.id}")

    within '.user-profile' do
      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{@user.address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip: #{@user.zip}")
      expect(page).to have_content("Email: #{@user.email}")
    end

    expect(page).to_not have_link('Edit Profile')
  end
end
