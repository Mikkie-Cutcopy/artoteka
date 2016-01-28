module RedisModelAccess
  extend ActiveSupport::Concern

  included do
    REDIS_MODEL_NAMESPACE = Imaginarium::RedisModel
  end

  def bind_redis_object
    redis_model.new.bind_to!(self)
  end

  def redis_object
    redis_model.redis_find(self.redis_token) if self.persisted?
  end

  def redis_model
    [REDIS_MODEL_NAMESPACE, self.class].map(&:to_s).join('::').constantize
  end
end