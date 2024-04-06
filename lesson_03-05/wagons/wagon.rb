class Wagon
  include Manufactor

  attr_reader :number

  def initialize(number)
    @number = number
  end
end
