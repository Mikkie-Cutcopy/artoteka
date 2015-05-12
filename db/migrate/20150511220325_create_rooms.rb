class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :number
      t.integer :owner_id
      t.boolean  :active
    end
  end
end
