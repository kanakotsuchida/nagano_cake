class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
    t.integer :customer_id, null: false
      t.string :name, null: false, unique: true
      t.string :postal_code, null: false
      t.string :address, null: false
      t.timestamps null: false
    
    
    
    t.timestamps
    end
  end
end
