require_relative 'car'
require_relative 'truck'
require_relative 'sport_car'

puts 'Creating and starting car'
car = Car.new
car.start_engine
puts car.current_rpm

puts 'Creating and starting truck'
truck = Truck.new
truck.start_engine
puts truck.current_rpm

puts 'Creating and starting sport car'
sport_car = SportCar.new
sport_car.start_engine
puts sport_car.current_rpm