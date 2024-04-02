class PassengerWagon < Wagon
  def initialize(number, type = 0)
    super(number, type)
    puts "Пассажирский вагон с номером: #{number} создан!"
  end

end