class PassengerTrain < Train
  attr_reader :type

  @trains = {}

  def initialize(number)
    @type = :passenger
    super
  end
end
