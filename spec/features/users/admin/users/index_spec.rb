require 'rails_helper'

describe "Admin users index page" do
  before(:each) do
    @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)

    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)
    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )

    @non_admin = [@user, @merchant_employee, @merchant_admin]
  end

  it "admin can see all users in the system" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit '/admin'

    click_link 'Users'

    expect(current_path).to eq("/admin/users")

    within "#user-#{@user.id}" do
      expect(page).to have_link(@user.name)
      expect(page).to have_content(@user.created_date)
      expect(page).to have_content(@user.role)
    end

    within "#user-#{@merchant_employee.id}" do
      expect(page).to have_link(@merchant_employee.name)
      expect(page).to have_content(@merchant_employee.created_date)
      expect(page).to have_content(@merchant_employee.role)
    end

    within "#user-#{@merchant_admin.id}" do
      expect(page).to have_link(@merchant_admin.name)
      expect(page).to have_content(@merchant_admin.created_date)
      expect(page).to have_content(@merchant_admin.role)
    end

    within "#user-#{@admin.id}" do
      expect(page).to have_link(@admin.name)
      expect(page).to have_content(@admin.created_date)
      expect(page).to have_content(@admin.role)
    end
  end

  it "as a user we can not visit the admin users page" do
    @non_admin.each do |user|
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      within ".topnav" do
        expect(page).to_not have_link('Users')
      end

      visit '/admin/users'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
