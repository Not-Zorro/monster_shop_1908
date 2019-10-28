class AddImageToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :image, :string, default: 'https://cdn2.mhpbooks.com/2018/07/cowboy-hat.png'
  end
end
