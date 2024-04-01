class PassengerWagon < Wagon
  def initialize(number, type)
    super(number, type)
    puts "Пассажирский вагон с номером: #{number} создан!"
  end

end