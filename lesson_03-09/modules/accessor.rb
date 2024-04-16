module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*attributes)
      attributes.each do |attribute|
        define_method("#{attribute}_history") { instance_variable_get("@#{attribute}_history") || [] }
        define_method(attribute) { instance_variable_get("@#{attribute}") }
        define_method("#{attribute}=") do |value|
          instance_variable_set("@#{attribute}", value)
          history = instance_variable_get("@#{attribute}_history") || []
          history << value
          instance_variable_set("@#{attribute}_history", history)
        end
      end
    end

    def strong_attr_accessor(attribute, type)
      define_method(attribute) { instance_variable_get("@#{attribute}") }
      define_method("#{attribute}=") do |value|
        raise ArgumentError, "Недопустимый формат! Получен #{type}, ожидалось #{value.class}" unless value.is_a?(type)

        instance_variable_set("@#{attribute}", value)
      end
    end
  end
end
