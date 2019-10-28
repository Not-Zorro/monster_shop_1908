require 'rails_helper'

describe 'as a merchant admin' do
  describe 'when i visit my items page' do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )


      @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    end
    it 'click button to deactivate item' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      within "#item-#{@pull_toy.id}" do
        click_button 'Deactivate'
      end

      within "#item-#{@dog_bone.id}" do
        expect(page).to_not have_button('Deactivate')
      end

      expect(current_path).to eq('/merchant/items')

      expect(page).to have_content("#{@pull_toy.name} is no longer for sale")

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_content('Inactive')
      end
    end

  end
end
# As a merchant admin
# When I visit my items page
# I see a link or button to deactivate the item next to each item that is active
# And I click on the "deactivate" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is no longer for sale
# I see the item is now inactive
