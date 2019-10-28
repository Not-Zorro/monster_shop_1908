require 'rails_helper'

RSpec.describe 'Cart show with items in cart' do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    @items_in_cart = [@paper,@tire,@pencil]
  end
  describe 'When I have added items to my cart as a visitor' do

    it 'Theres a link to checkout that flashes an error message' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/cart")

      expect(page).to have_content('Please login or register to continue')
    end
  end
end

describe 'Cart show without items in cart' do
  it 'There is not a link to checkout' do
    visit "/cart"

    expect(page).to_not have_link("Checkout")
  end
end

describe 'As a registered user with items in my cart' do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @user = User.create( name: 'Bob J',
                        address: '123 Fake St',
                        city: 'Denver',
                        state: 'Colorado',
                        zip: 80111,
                        email: 'user@user.com',
                        password: 'password')

    visit '/login'

    fill_in :email, with: 'user@user.com'
    fill_in :password, with: 'password'
    click_button 'Login'
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
    @items_in_cart = [@paper,@tire,@pencil]
  end

  it 'I can check out and see the order in my orders page' do
    visit '/cart'

    click_link 'Checkout'

    expect(current_path).to eq('/profile/orders')

    expect(page).to have_content('Thank you for placing your order')
    expect(page).to have_content('Cart: 0')
    order = Order.last

    within "#order-#{order.id}" do
      expect(page).to have_content("#{order.id}")
      expect(page).to have_content(order.status.capitalize)
    end
  end
end
