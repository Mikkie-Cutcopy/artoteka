module Connection::RedisMethods
  extend ActiveSupport::Concern

  class_methods do
    def redis_instance
      Redis.new(url: ENV["REDIS_URL"], driver: :hiredis)
    end
  end

  def redis_pub
    @redis_pub ||= self.class.redis_instance
  end

  def redis_sub
    @redis_sub ||= self.class.redis_instance
  end
end