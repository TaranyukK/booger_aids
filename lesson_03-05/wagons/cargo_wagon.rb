class CargoWagon < Wagon
  attr_reader :type

  def initialize(number)
    @type = :cargo
    super
  end
end
