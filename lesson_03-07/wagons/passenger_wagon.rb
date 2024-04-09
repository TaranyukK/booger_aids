class PassengerWagon < Wagon
  attr_reader :type, :seats, :free_seats

  def initialize(number, seats)
    @type = :passenger
    @seats = seats
    @free_seats = seats
    super(number)
  end

  def take_seat
    take_seat!
  end

  def occupied_seats
    seats - free_seats
  end

  private

  attr_writer :free_seats

  def take_seat!
    self.free_seats -= 1 if free_seats.positive?
  end
end
