class RenameAuthToken < ActiveRecord::Migration
  def change
    rename_column :rooms, :auth_token, :redis_token
    rename_column :gamers, :auth_token, :redis_token
  end
end
