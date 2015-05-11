class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :number, :primary_key
      t.string :owner
      t.string :owner_email
      t.boolean :active
      t.timestamps
    end
  end
end
