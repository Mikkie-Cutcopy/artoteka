module RedisModelAccess

  def bind_redis_object
    redis_model.new.bind_to!(self)
  end

  def redis_object
    redis_model.redis_find(self.redis_token) if self.persisted?
  end

  def redis_model
    ('Imaginarium::RedisModel::' + self.class.name).constantize
  end
end