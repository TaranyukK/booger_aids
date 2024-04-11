class CargoTrain < Train
  attr_reader :type

  @trains = {}

  def initialize(number)
    @type = :cargo
    super
  end
end
