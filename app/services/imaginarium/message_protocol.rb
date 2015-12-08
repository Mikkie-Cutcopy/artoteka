module Imaginarium::MessageProtocol
  module_function

  def generate_redis_token
    SecureRandom.hex
  end
end