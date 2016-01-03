class Room < ActiveRecord::Base
  include RedisModelAccess

  default_value_for :redis_token do
    Imaginarium::MessageProtocol.generate_redis_token
  end
  has_many  :gamers
  has_many  :users, through: :gamers
  validates  :number, uniqueness: true

  after_create :bind_redis_object

  DEFAULT_MAX_NUMBER = 10000
  DEFAULT_MIN_NUMBER = 1000

  def self.generate_number(limit=nil)
    persisted = pluck(:number)
    limit ||= DEFAULT_MAX_NUMBER
    if persisted.count < (limit - DEFAULT_MIN_NUMBER)
      limit.times do
        num = SecureRandom.random_number(limit)
        return num if !(persisted.include?(num)) && num > DEFAULT_MIN_NUMBER
      end
    end
    generate_number(limit*10)
  end

  def owner
    gamers.where(owner: true).first
  end

end
