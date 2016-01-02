module Imaginarium::Controller
  class AuthenticationsController < InitialController
    def create
      adapter.redis_token = params['redis_token']
      {status: 200}
    end
  end
end