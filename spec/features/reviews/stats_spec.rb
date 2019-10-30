require 'rails_helper'

RSpec.describe 'Review statistics', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @user = User.create!(name: 'Customer Sally', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
    @user_2 = User.create!(name: 'Second Customer', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user2@user.com', password: 'password' )

  end
  describe "When I visit an items show page" do
    it "I can see an area at the top of the page for statistics about reviews" do
      review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5, user_id: @user.id)
      review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4, user_id: @user_2.id)
      review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1, user_id: @user_2.id)
      review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2, user_id: @user_2.id)
      review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3, user_id: @user_2.id)

      visit "/items/#{@chain.id}"

      expect(page).to have_css(".review-stats")
      within ".review-stats" do
        within ".top-three-reviews" do
          expect(page).to have_content(review_1.title)
          expect(page).to have_content(review_1.rating)
          expect(page).to have_content(review_2.title)
          expect(page).to have_content(review_2.rating)
          expect(page).to have_content(review_5.title)
          expect(page).to have_content(review_5.rating)
        end

        within ".bottom-three-reviews" do
          expect(page).to have_content(review_3.title)
          expect(page).to have_content(review_4.title)
          expect(page).to have_content(review_5.title)
          expect(page).to have_content(review_3.rating)
          expect(page).to have_content(review_4.rating)
          expect(page).to have_content(review_5.rating)
        end
      end

      within "#average-rating" do
        expect(page).to have_content("Average Rating: 3.0")
      end
    end
  end
end
