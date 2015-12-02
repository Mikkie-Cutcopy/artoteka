class DelegateFunctionalityToUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :single_access_token
      t.string :perishable_token
      t.timestamps
    end
    add_column :gamers, :user_id, :integer
    add_column :rooms, :was_removed, :boolean
    remove_columns :gamers, :name, :email
  end
end
