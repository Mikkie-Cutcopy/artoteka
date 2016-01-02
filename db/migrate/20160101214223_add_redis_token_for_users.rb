class AddRedisTokenForUsers < ActiveRecord::Migration
  def change
    add_column :users, :redis_token, :string
  end
end
