module Imaginarium::Controller
  class ApplicationController < Base
    attr_accessor :current_gamer

    def identification
      @current_gamer = Imaginarium::RedisModel::Gamer.redis_find(params['auth_token'])
    end

  end
end