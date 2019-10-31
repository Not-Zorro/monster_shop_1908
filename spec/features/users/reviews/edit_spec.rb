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

  describe "when I visit the item show page as a logged-in user" do
    it "I only see a link called Edit next to the review that I've made" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5, user_id: @user.id)
      review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4, user_id: @user_2.id)
      review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1, user_id: @user_2.id)
      review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2, user_id: @user_2.id)
      review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3, user_id: @user_2.id)

      reviews_user_2 = [review_2,review_3,review_4,review_5]

      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        expect(page).to have_link("Edit")
      end

      reviews_user_2.each do |review|
        within "#review-#{review.id}" do
          expect(page).to_not have_link("Edit")
        end
      end
    end

    it "I can edit a review when I fill in all of the fields" do
      review_1 = @chain.reviews.create(user_id: @user.id, title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      title = "Nice Bike Shop!"
      content = "It's great!"
      rating = 4

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        click_on "Edit"
      end

      expect(current_path).to eq("/items/#{@chain.id}/profile/reviews/#{review_1.id}/edit")
      expect(find_field(:title).value).to eq(review_1.title)
      expect(find_field(:content).value).to eq(review_1.content)
      expect(find_field(:rating).value).to eq(review_1.rating.to_s)

      fill_in :title, with: title
      fill_in :content, with: content
      fill_in :rating, with: rating

      click_on "Update Review"

      expect(current_path).to eq("/items/#{@chain.id}")
      within "#review-#{review_1.id}" do
        expect(page).to have_content(title)
        expect(page).to have_content(content)
        expect(page).to have_content(rating)
      end
    end

    it "I can edit a review when I fill in just some of the fields" do
      review_1 = @chain.reviews.create(user_id: @user.id, title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      title = "Nice Bike Shop!"

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/items/#{@chain.id}"

      within "#review-#{review_1.id}" do
        click_on "Edit"
      end

      fill_in :title, with: title

      click_on "Update Review"

      expect(current_path).to eq("/items/#{@chain.id}")
      within "#review-#{review_1.id}" do
        expect(page).to have_content(title)
        expect(page).to_not have_content(review_1.title)
        expect(page).to have_content(review_1.content)
        expect(page).to have_content(review_1.rating)
      end
    end

  end
end
