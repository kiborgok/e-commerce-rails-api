class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :imageSrc
      t.belongs_to :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
