class RemoveImageFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :image, :string
  end
end
