class CargoWagon < Wagon

  def initialize(number, type)
    super(number, type)
    puts "Грузовой вагон с номером: #{number} создан!"
  end
end