module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(attr_name, validation_type, *args)
      @validations ||= []
      @validations << { attr_name: attr_name, validation_type: validation_type, args: args }
    end
  end

  module InstanceMethods
    def validate!
      src = self.class.superclass == Object ? self.class : self.class.superclass

      src.validations.each do |validation|
        value = instance_variable_get("@#{validation[:attr_name]}")
        send(validation[:validation_type].to_sym, validation[:attr_name], value, *validation[:args])
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(attr_name, value)
      raise ArgumentError, "#{attr_name.capitalize} не может быть пустым!" if value.nil? || value.empty?
    end

    def format(attr_name, value, regex)
      raise ArgumentError, "#{attr_name.capitalize} имеет недопустимый формат!" unless value =~ regex
    end

    def type(attr_name, value, expected_class)
      raise ArgumentError, "#{attr_name.capitalize} имеет неверный тип!" unless value.is_a?(expected_class)
    end
  end
end
