module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(attr_name, validation_type, *args)
      @validations ||= []
      @validations << { attr_name: attr_name, validation_type: validation_type, args: args }
    end

    def validations
      @validations || []
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        attr_name = validation[:attr_name]
        validation_type = validation[:validation_type]
        args = validation[:args]

        send(validation_type, attr_name, *args)
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def presence(attr_name, *)
      value = instance_variable_get("@#{attr_name}")
      raise "#{attr_name.capitalize} не может быть пустым!" if value.nil? || value.empty?
    end

    def format(attr_name, regex)
      value = instance_variable_get("@#{attr_name}")
      raise "#{attr_name.capitalize} имеет недопустимый формат!" unless value =~ regex
    end

    def type(attr_name, expected_class)
      value = instance_variable_get("@#{attr_name}")
      raise "#{attr_name.capitalize} имеет неверный тип!" unless value.is_a?(expected_class)
    end
  end
end
