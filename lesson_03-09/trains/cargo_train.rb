class CargoTrain < Train
  attr_reader :type

  @trains = {}

  def initialize(number)
    super
    @type = :cargo
  end
end
