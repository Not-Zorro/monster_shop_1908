require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end

  describe 'relationships' do
    it { should have_many :orders }
    it { should have_many :reviews }
  end

  describe 'roles' do
    it "can be created by a default user" do
      user = User.create( name: 'Bob J',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'user@user.com',
                          password: 'password')

      expect(user.role).to eq('default')
      expect(user.default?).to be_truthy
    end
    it "can create a merchant employee role" do
      merchant_employee = User.create( name: 'Sally Q',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'merchant_employee@merchant_employee.com',
                          password: 'password',
                          role: 1)

      expect(merchant_employee.role).to eq('merchant_employee')
      expect(merchant_employee.merchant_employee?).to be_truthy
    end
    it "can create a merchant admin role" do
      merchant_admin = User.create( name: 'David L',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'merchant_admin@merchant_admin.com',
                          password: 'password',
                          role: 2)

      expect(merchant_admin.role).to eq('merchant_admin')
      expect(merchant_admin.merchant_admin?).to be_truthy
    end
    it "can create an admin role" do
      admin = User.create( name: 'Brian Q',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'admin@admin.com',
                          password: 'password',
                          role: 3)

      expect(admin.role).to eq('admin')
      expect(admin.admin?).to be_truthy
    end
  end

  describe 'instance methods' do
    before(:each) do
      @user = User.create( name: 'Bob J',
                          address: '123 Fake St',
                          city: 'Denver',
                          state: 'Colorado',
                          zip: 80111,
                          email: 'user@user.com',
                          password: 'password',
                          created_at: 'Fri, 18 Oct 2019 21:56:35 UTC +00:00')
    end

    it 'returns boolean for if a user has orders' do
      expect(@user.has_orders?).to be_falsy
      order = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip)

      expect(@user.has_orders?).to be_truthy
    end

    it 'returns a created date in FullMonth Day, Year' do
      expect(@user.created_date).to eq('October 18, 2019')
    end
  end
end
