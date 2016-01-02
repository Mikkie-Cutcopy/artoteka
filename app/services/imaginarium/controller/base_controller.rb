module Imaginarium::Controller
  class BaseController
    abstract
    attr_reader :adapter, :params
    @@before_callbacks ||= []
    @@after_callbacks ||= []

    def self.hundle(env)
      new(env).execute
    end

    def self.before(method_name, attr={})
      attr = attr.slice(:only, :except)
      @@before_callbacks << {method_name: method_name.to_sym, attr: attr}
    end

    def self.after(method_name, attr)
      attr = attr.slice(:only, :except)
      @@after_callbacks << {method_name: method_name.to_sym, attr: attr}
    end

    def initialize(env)
      @adapter = env['adapter']
      @command = env['command']
      @params = env['params']
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
        if callback_available_for(@command, callback)
          send(callback[:method_name])
        end
      end
    end

    def callback_available_for(command, callback)
      callback[:attr][:only].try{|arr| arr.include?(command)} || !callback[:attr][:except].try{|arr| arr.include?(command)}
    end

  end
end