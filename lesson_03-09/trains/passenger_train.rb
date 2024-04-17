class PassengerTrain < Train
  attr_reader :type

  @trains = {}

  def initialize(number)
    super
    @type = :passenger
  end
end
