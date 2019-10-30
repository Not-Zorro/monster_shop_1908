require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'returns the quantity ordered for the item' do
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 2)

      expect(@chain.quantity_ordered(order_1.id)).to eq 2
    end

    it 'returns boolean of fulfillment status' do
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      item_order_1 = order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 2)

      expect(@chain.fulfilled?(order_1.id)).to be_falsy
    end

    it 'returns boolean of can_fulfill status' do
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      item_order_1 = order_1.item_orders.create(item: @chain, price: @chain.price, quantity: 2)

      expect(@chain.can_fulfill?(order_1.id)).to be_truthy
    end

    it "can return its active status" do
      ball = @bike_shop.items.create!(name: "Tennis ball", description: "It's Green!", price: 1, image: "https://www.salemacademycs.org/wp-content/uploads/Tennis-balls.jpg", inventory: 500, active?: false)

      expect(@chain.status).to eq('Active')
      expect(ball.status).to eq('Inactive')
    end

    it "can calculate return top and bottom 5 items name and quantity ordered" do
      user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

      pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      dog_leash = @bike_shop.items.create(name: "Dog Leash", description: "It's a dog leash!", price: 15, inventory: 50)
      kong_toy = @bike_shop.items.create(name: "Kong Toy", description: "Konggggggg!", price: 30, inventory: 30)
      dog_booties = @bike_shop.items.create(name: "Dog Booties", description: "You can walk in the snow!", price: 100, inventory: 20)
      dog_carrier = @bike_shop.items.create(name: "Canine Sports Sack", description: "You can hike with your dog in a sack!", price: 150, inventory: 22)
      dog_beard_butter = @bike_shop.items.create(name: "Dog Beard Butter", description: "The softest fur in barktown!", price: 20, inventory: 100)

      order_1 = user.orders.create!(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip, user_id: user.id)

      item_order_1 = order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 1)
      item_order_2 = order_1.item_orders.create!(item: dog_leash, price: dog_leash.price, quantity: 2)
      item_order_3 = order_1.item_orders.create!(item: dog_booties, price: dog_booties.price, quantity: 3)
      item_order_4 = order_1.item_orders.create!(item: dog_carrier, price: dog_carrier.price, quantity: 4)
      item_order_5 = order_1.item_orders.create!(item: dog_beard_butter, price: dog_beard_butter.price, quantity: 5)
      item_order_6 = order_1.item_orders.create!(item: kong_toy, price: kong_toy.price, quantity: 6)

      top_expected_hash = {kong_toy => 6, dog_beard_butter => 5, dog_carrier => 4, dog_booties => 3, dog_leash => 2}

      expect(Item.all.item_stats("desc")).to eq(top_expected_hash)

      bottom_expected_hash = {pull_toy => 1, dog_leash => 2, dog_booties => 3, dog_carrier => 4, dog_beard_butter => 5}

      expect(Item.all.item_stats("asc")).to eq(bottom_expected_hash)
    end
  end
end