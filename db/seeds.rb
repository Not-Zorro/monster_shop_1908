# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
outdoor_shop = Merchant.create(name: "Snow's Outdoor Bonanza", address: '56 Mountain Rd.', city: 'Aspen', state: 'CO', zip: 80456)
computer_store = Merchant.create(name: "Elliot's Computer Parts", address: '123 CPU Way.', city: 'Littleton', state: 'CO', zip: 80128)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#outdoor_shop items
boots = outdoor_shop.items.create(name: "Hikin' Boots", description: "They keep your feet warm and dry!", price: 150, inventory: 3)
backpack = outdoor_shop.items.create(name: "Backpack", description: "To keep your stuff dry and warm!", price: 200, inventory: 5)
protein_bars = outdoor_shop.items.create(name: "Protein Bars", description: "To keep your tummy full and happy!", price: 2, inventory: 50)
hiking_shorts = outdoor_shop.items.create(name: "Shorts", description: "To keep your legs nice and cool!", price: 25, inventory: 5, active?: false)

#computer_store parts
thirty_two_gigs_of_ram = computer_store.items.create(name: "32 Gb DDR4 RAM", description: "To keep your computer fast and you happy!", price: 200, inventory: 17, image: "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6333/6333800_sd.jpg")
gpu = computer_store.items.create(name: "RTX1080TI Graphics Processing Unit", description: "To keep your computer fast and you happy x2!", price: 500, inventory: 4, image: "https://eteknix-eteknixltd.netdna-ssl.com/wp-content/uploads/2017/03/DSC_3511.jpg")
rgb_keyboard = computer_store.items.create(name: "RGB Keyboard", description: "Better gaming capabilities!", price: 60, inventory: 20, image: "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/5707/5707081_sd.jpg")

#users
user = User.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'user@user.com', password: 'password' )

bike_shop_employee = bike_shop.users.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchemp@bikeshop.com', password: 'password', role: 1)
dog_shop_employee = dog_shop.users.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchemp@dogshop.com', password: 'password', role: 1)
outdoor_shop_employee = outdoor_shop.users.create(name: 'Sally Q', address: '456 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchemp@outdoorshop.com', password: 'password', role: 1)
computer_store_employee = computer_store.users.create(name: 'David L', address: '8880 Real Blvd', city: 'Littleton', state: 'Colorado', zip: 80134, email: 'merchemp@computershop.com', password: 'password', role: 1)

bike_shop_admin = bike_shop.users.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchad@bikeshop.com', password: 'password', role: 2)
dog_shop_admin = dog_shop.users.create(name: 'Bob J', address: '123 Fake St', city: 'Denver', state: 'Colorado', zip: 80111, email: 'merchad@dogshop.com', password: 'password', role: 2)
outdoor_shop_admin = outdoor_shop.users.create(name: 'Cliff Hanger', address: '55 Cliff Hanger Way', city: 'Grand Junction', state: 'Colorado', zip: 80234, email: 'merchad@outdoorshop.com', password: 'password', role: 2)
computer_store_admin = computer_store.users.create(name: 'Bill Gates', address: '1 Rich Ln.', city: 'Vail', state: 'Colorado', zip: 80001, email: 'merchad@computerstore.com', password: 'password', role: 2)

admin = User.create(name: 'Andrea Admin', address: '2 Admin Ave', city: 'Aspen', state: 'Colorado', zip: 80111, email: 'admin@admin.com', password: 'password', role: 3)

#computer_items_reviews
ram_review_1 = thirty_two_gigs_of_ram.reviews.create(user_id: user.id, title: 'It is pretty cheap', content: "It does what it says but only gets up to 3.5 gigahertz.", rating: 3)
ram_review_2 = thirty_two_gigs_of_ram.reviews.create(user_id: user.id, title: 'It is amazing', content: "It is sooooo fast!", rating: 5)
ram_review_3 = thirty_two_gigs_of_ram.reviews.create(user_id: user.id, title: 'Ram is Ram', content: "It works.", rating: 4)
ram_review_3 = thirty_two_gigs_of_ram.reviews.create(user_id: user.id, title: "This didn't have RGB. It lied!!!", content: "What a waste of money. This is trash!", rating: 1)

#orders and item orders
order_1 = user.orders.create(name: user.name, address: user.address, city: user.city, state: user.state, zip: user.zip, user_id: user.id)
item_order_1 = order_1.item_orders.create(item: tire, price: tire.price, quantity: 1)
item_order_2 = order_1.item_orders.create(item: gpu, price: gpu.price, quantity: 2)
item_order_3 = order_1.item_orders.create(item: boots, price: boots.price, quantity: 3)
item_order_4 = order_1.item_orders.create(item: thirty_two_gigs_of_ram, price: thirty_two_gigs_of_ram.price, quantity: 4)
item_order_5 = order_1.item_orders.create(item: backpack, price: backpack.price, quantity: 5)
item_order_6 = order_1.item_orders.create(item: rgb_keyboard, price: rgb_keyboard.price, quantity: 6)
item_order_7 = order_1.item_orders.create(item: protein_bars, price: protein_bars.price, quantity: 10)
