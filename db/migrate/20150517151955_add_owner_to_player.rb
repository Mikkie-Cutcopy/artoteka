class AddOwnerToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :owner, :boolean
  end
end
