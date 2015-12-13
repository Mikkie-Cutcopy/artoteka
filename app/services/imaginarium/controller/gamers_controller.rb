module Imaginarium::Controller
  class GamersController < ApplicationController
    before :identification

    def connect
      self.params
      #берем token геймера
      #добавяем в модель игры
      #посылаем остальным участникам команду на обновление страницы
    end

    def disconnect

    end
  end
end