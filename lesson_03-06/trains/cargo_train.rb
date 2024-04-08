class CargoTrain < Train
  @trains = {}

  def initialize(number)
    @type = :cargo
    super
  end
end
