module ISBN
  class Validations  
    def self.clean(isbn)
      isbn.upcase.gsub(/[^0-9X]/, '')
    end

    def self.looks_valid?(isbn)
      return /^(?:\d{9}[0-9X]|97[89]\d{10})$/.match(isbn)
    end

    def self.is_valid?(isbn)
      isbn = clean(isbn)
      return false unless looks_valid?(isbn)

      bits = isbn.split(//)
      sum = 0
      if isbn.length == 10
        10.downto(2) do |pos|
          sum += pos * bits.shift.to_i
        end
        checksum = bits[0] == 'X' ? 10 : bits[0].to_i
        return ((sum + checksum) % 11) == 0
      else
        0.step(10, 2) do |pos|
          sum += bits[pos].to_i
        end
        1.step(11, 2) do |pos|
          sum += bits[pos].to_i * 3
        end
        return ((sum + bits[12].to_i) % 10) == 0
      end
    end 
  end
end

module ActiveRecord
  module Validations
    module ClassMethods
      def validates_as_isbn(*attr_names)
        configuration = {
          :message  => 'is not a valid ISBN'
        }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless ISBN::Validations.is_valid?(value)
            record.errors.add(attr_name, configuration[:message])
          end
        end
      end
    end
  end
end