module Connection::MessageProtocol
  module_function

  CONTROLLERS_PATH = 'imaginarium/controller'

  class Request
    def initialize(data)
      @env = data
    end

    def call
      begin
        controller.hundle(@env)
      rescue NameError
      end
    end

    private

    def controller

      routes_resolve(@env['entity'])
    end

    def routes_resolve(entity)
      (CONTROLLERS_PATH.camelize + '::' + entity.classify.pluralize + 'Controller').constantize
    end
  end


  def generate_redis_token
    SecureRandom.hex
  end


end