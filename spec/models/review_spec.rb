require 'rails_helper'

describe Review, type: :model do

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :user}
  end

end
