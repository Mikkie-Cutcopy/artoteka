module Imaginarium::Controller
  class BaseController
    abstract
    attr_accessor :params
    @@before_callbacks ||= []
    @@after_callbacks ||= []

    def self.hundle(env)
      new(env['command'], env['params']).execute
    end

    def self.before(method_name, attr={})
      attr = attr.slice(:only, :except)
      @@before_callbacks << {method_name: method_name.to_sym, attr: attr}
    end

    def self.after(method_name, attr)
      attr = attr.slice(:only, :except)
      @@after_callbacks << {method_name: method_name.to_sym, attr: attr}
    end

    def initialize(command, params)
      @command = command
      @params = params
    end

    def execute
      with_callbacks do
        send(@command.to_sym)
      end
    end

    def with_callbacks
      execute_callbacks(@@before_callbacks)
      response = yield
      execute_callbacks(@@after_callbacks)
      response
    end

    def execute_callbacks(callbacks)
      return if callbacks.empty?
      callbacks.each do |callback|
        if callback[:attr][:only].try{|arr| arr.include?(@command)} || !callback[:attr][:except].try{|arr| arr.include?(@command)}
          send(callback[:method_name])
        end
      end
    end

  end
end