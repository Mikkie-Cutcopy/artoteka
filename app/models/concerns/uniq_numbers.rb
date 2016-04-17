module UniqNumbers
  extend ActiveSupport::Concern

  DEFAULT_MAX_NUMBER = 10000
  DEFAULT_MIN_NUMBER = 1000

  class_methods do
    def generate_number(limit=nil)
      persisted = pluck(:number)
      limit ||= DEFAULT_MAX_NUMBER
      if persisted.count < (limit - DEFAULT_MIN_NUMBER)
        limit.times do
          num = SecureRandom.random_number(limit)
          return num if !(persisted.include?(num)) && num > DEFAULT_MIN_NUMBER
        end
      end
      generate_number(limit*10)
    end
  end
end