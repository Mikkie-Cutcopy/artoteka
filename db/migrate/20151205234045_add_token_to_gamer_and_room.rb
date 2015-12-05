class AddTokenToGamerAndRoom < ActiveRecord::Migration
  def change
    add_column :gamers, :auth_token, :string
    add_column :rooms,  :auth_token, :string
  end
end
