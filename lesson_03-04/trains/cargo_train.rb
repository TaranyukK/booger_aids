class CargoTrain < Train
  attr_reader :type_human

  def initialize(number, type = 1)
    super
    @type_human = 'грузовой'
    puts "Грузовой поезд с номером - #{number} создан!"
  end

end