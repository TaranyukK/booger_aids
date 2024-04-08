class PassengerTrain < Train
  @trains = {}

  def initialize(number)
    @type = :passenger
    super
  end
end
