class Wagon
  include Manufactor
  include Validation
  include Accessors

  NUMBER_FORMAT = /^[a-z0-9]{5}$/i.freeze

  attr_reader :number

  attr_accessor_with_history :number
  strong_attr_accessor :number, String

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :type, String

  def initialize(number)
    @number = number
    validate!
  end

  def passenger?
    type == :passenger
  end

  private

  def validate!
    raise 'Номер не может быть пустым!' if number.empty?
    raise 'Длинна номера должна быть минимум 5 символов!' if number.length < 5
    raise 'Неверный формат номера!' if number !~ NUMBER_FORMAT
  end
end
