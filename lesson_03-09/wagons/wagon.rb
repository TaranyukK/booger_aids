class Wagon
  include Manufactor
  include Validation
  include Accessors

  attr_reader :number

  validate :number, :presence
  validate :number, :format, /^[a-z0-9]{5}$/i

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
