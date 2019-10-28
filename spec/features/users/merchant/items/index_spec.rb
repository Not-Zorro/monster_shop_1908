require 'rails_helper'

describe 'as a merchant admin' do
  describe 'when i visit my items page' do
    before(:each) do
      @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)
      @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )
      @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
      @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )


      @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      @ball = @chester_the_merchant.items.create!(name: "Tennis ball", description: "It's Green!", price: 1, image: "https://www.salemacademycs.org/wp-content/uploads/Tennis-balls.jpg", inventory: 500, active?: false)
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

    it "Can not deactivate or see button as a merchant_employee" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
      visit '/merchant/items'

      within "#item-#{@pull_toy.id}" do
        expect(page).to_not have_button('Deactivate')
      end
    end

    it 'click button to activate item' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)
      visit '/merchant/items'

      within "#item-#{@ball.id}" do
        click_button 'Activate'
      end

      expect(current_path).to eq('/merchant/items')

      expect(page).to have_content("#{@ball.name} is for sale")

      within "#item-#{@ball.id}" do
        expect(page).to have_content('Active')
      end
    end

    it "Can not activate or see button as a merchant_employee" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
      visit '/merchant/items'

      within "#item-#{@ball.id}" do
        expect(page).to_not have_button('Activate')
      end
    end
  end
end
