class PassengerWagon < Wagon
  attr_reader :type

  def initialize(number)
    @type = :passenger
    super
  end
end
