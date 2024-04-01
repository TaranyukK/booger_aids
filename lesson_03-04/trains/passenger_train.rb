class PassengerTrain < Train
  attr_reader :type_human

  def initialize(number, type)
    super
    @type_human = 'пассажирский'
    puts "Пассажирский поезд с номером - #{number} создан!"
  end

end