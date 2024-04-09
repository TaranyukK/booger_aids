class Wagon
  include Manufactor
  include Validation

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
  end

  def passenger?
    type == :passenger
  end

  private

  def validate!
    raise 'Длинна номера должна быть минимум 5 символов!' if number.length < 5
  end
end
