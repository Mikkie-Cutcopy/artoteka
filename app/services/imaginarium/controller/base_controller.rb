module Imaginarium::Controller
  class Base
    def self.hundle(env)
      new(env['params']).execute(env['command'])
    end

    def initialize(params)
      @params = params
    end

    def execute(command)
      send(command.to_sym)
    end
  end
end