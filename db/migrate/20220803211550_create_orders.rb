class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.string :location
      t.string :phone
      t.float :amount
      t.float :shipping
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
