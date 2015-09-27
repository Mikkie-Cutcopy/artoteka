class RenameTable < ActiveRecord::Migration
  def change
    rename_table :players, :gamers
  end
end
