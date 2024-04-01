class Wagon
  attr_reader :number, :type

  TYPES = [:passenger, :cargo]

  def initialize(number, type)
    @number = number
    @type = TYPES[type]
  end
end