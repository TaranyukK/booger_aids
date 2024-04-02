class CargoWagon < Wagon

  def initialize(number, type = 1)
    super(number, type)
    puts "Грузовой вагон с номером: #{number} создан!"
  end
end