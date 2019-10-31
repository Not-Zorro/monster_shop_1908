require 'rails_helper'

RSpec.describe 'review edit and update', type: :feature do
  before(:each) do
    @chester_the_merchant = Merchant.create!(name: "Chester's Shop", address: '456 Terrier Rd.', city: 'Richmond', state: 'VA', zip: 23137)

    @admin = User.create!(name: 'Admin Foxy', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)
    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @user_2 = User.create!(name: 'Second Customer', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user2@user.com', password: 'password' )

    @merchant_employee = @chester_the_merchant.users.create!(name: 'Drone', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'employee@employee.com', password: 'password', role: 1 )
    @merchant_admin = @chester_the_merchant.users.create!(name: 'Boss', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'boss@boss.com', password: 'password', role: 2 )

    @pull_toy = @chester_the_merchant.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @chester_the_merchant.items.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

  end
  describe "when I visit the item show page" do
    it "I see a link next to my review to delete it" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5, user_id: @user.id)
      review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4, user_id: @user_2.id)
      review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1, user_id: @user_2.id)
      review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2, user_id: @user_2.id)
      review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3, user_id: @user_2.id)

      reviews_user_2 = [review_2,review_3,review_4,review_5]

      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        expect(page).to have_link("Delete")
      end

      reviews_user_2.each do |review|
        within "#review-#{review.id}" do
          expect(page).to_not have_link("Delete")
        end
      end
    end

    it "I can delete a review when I click on delete" do
      review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5, user_id: @user.id)
      review_1_id = review_1.id
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        click_on "Delete"
      end

      expect(current_path).to eq("/items/#{@chain.id}")
      expect(page).to_not have_css("#review-#{review_1_id}")
    end

    it "As an admin I can delete any review regardless of user" do
      review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5, user_id: @user.id)
      review_1_id = review_1.id
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        click_on "Delete"
      end

      expect(current_path).to eq("/items/#{@chain.id}")
      expect(page).to_not have_css("#review-#{review_1_id}")

    end
  end
end
