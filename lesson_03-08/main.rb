require_relative 'modules/manufactor'
require_relative 'modules/constant'
require_relative 'modules/helper'
require_relative 'modules/validation'
require_relative 'modules/instance_counter'
require_relative 'modules/seed'
require_relative 'modules/menu'
require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/passenger_train'
require_relative 'trains/cargo_train'
require_relative 'wagons/wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'wagons/cargo_wagon'

class RealRailways
  include Menu
  include Helper
  include Seed

  attr_reader :stations, :routes, :trains, :wagons

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
    puts 'ОАО `РЖД`(Реальные Железные Дороги) приветсвуют вас!'
  end

  def start
    loop do
      show_items(MENU)
      case answer_i
      when 1
        all_trains
      when 2
        routes_and_stations
      when 3
        stations_and_trains
      when 4
        puts 'До свидания!'
        return
      else
        puts wrong_attribute
      end
    end
  end

  def seed
    create_stations
    create_routes
    create_passenger_trains
    create_cargo_trains
    create_wagons
  end

  private

  # action methods
  def create_train
    puts 'Создание поезда'
    loop do
      puts 'Введите номер поезда:'
      train_number = answer
      puts 'Введите тип поезда 1 - пассажирский, 2 - грузовой'
      case answer_i
      when 1
        trains << PassengerTrain.new(train_number)
      when 2
        trains << CargoTrain.new(train_number)
      else
        puts wrong_attribute
      end
      puts "Создан поезд №#{train_number}"
      return
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def choose_train
    choose_item(trains, 'поезд') { |train| "#{train.passenger? ? 'Пассажирский' : 'Грузовой'} поезд №#{train.number}" }
  end

  def choose_wagon(train)
    choose_item(train.wagons, 'вагон') do |wagon|
      "Вагон №#{wagon.number} - свободно: #{wagon.passenger? ? wagon.free_seats : wagon.free_space}"
    end
  end

  def choose_route
    choose_item(routes, 'маршрут') { |route| "#{route.first_station.name}--#{route.last_station.name}" }
  end

  def choose_station
    choose_item(stations, 'станцию') { |station| "Станция: #{station.name}" }
  end

  def add_wagon_to_train(train)
    puts 'Создание вагона'
    loop do
      puts 'Введите номер вагона:'
      wagon_number = answer
      new_wagon = case train.type
                  when :passenger
                    puts 'Введите количество мест:'
                    seats = answer_i
                    PassengerWagon.new(wagon_number, seats)
                  when :cargo
                    puts 'Введите объем:'
                    volume = answer_i
                    CargoWagon.new(wagon_number, volume)
                  end
      wagons << new_wagon
      train.wagons << new_wagon
      puts "Создан вагон №#{wagon_number}"
      return
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def remove_wagon_from_train(train)
    wagon = choose_wagon(train)
    train.remove_wagon(wagon)
  end

  def add_route_to_train(train)
    route = choose_route
    train.take_route(route)
  end

  def create_station
    puts 'Создание станции'
    puts 'Введите название станции:'
    station_name = answer.chomp
    stations << Station.new(station_name)
  end

  def create_route
    puts 'Создание маршрута'
    puts 'Выберите начальную станцию:'
    start_station = choose_station
    puts 'Выберите конечную станцию:'
    end_station = choose_station
    if start_station && end_station
      routes << Route.new(start_station, end_station)
    else
      puts 'Ошибка: Некорректно выбраны начальная или конечная станция.'
    end
  end

  def add_station_to_route
    puts 'Выберите маршрут'
    all_routes
    loop do
      answer = answer_i
      if routes[answer]
        route = routes[answer]
        puts 'Выберите станцию для добавления:'
        all_stations(stations - route.stations)
        station_index = answer_i
        route.add_station(route.stations[station_index])
      else
        puts wrong_attribute
      end
    end
  end

  def remove_station_from_route
    puts 'Выберите маршрут:'
    route = choose_route
    return unless route

    puts 'Выберите станцию для удаления:'
    station = choose_station(route.stations)
    route.remove_station(station) if station
  end

  def show_stations_and_routes
    routes.each do |route|
      puts "#{route.first_station.name} -- #{route.last_station.name}"
      puts 'Станции:'
      all_stations(route.stations)
      puts bold_delimiter
    end
  end

  def all_stations(stations = self.stations)
    stations.each_with_index { |station, index| puts "#{index}. №#{station.name}" }
  end

  def all_routes
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name}--#{route.last_station.name}" }
  end

  def show_wagons(train)
    puts 'Вагоны:'
    train.each_wagon do |wagon|
      print "№#{wagon.number} - тип: "
      if wagon.passenger?
        print 'пассажирский, '
        puts "свободных мест: #{wagon.free_seats}, занято: #{wagon.occupied_seats}"
      else
        print 'грузовой, '
        puts "свободного объема: #{wagon.free_space}, занято: #{wagon.occupied_space}"
      end
    end
  end

  def stations_and_trains
    stations.each do |station|
      puts "Станция: #{station.name}"
      if station.trains.empty?
        puts 'У станции нет поездов!'
      else
        puts 'Поезда:'
        station.each_train do |train|
          puts "№#{train.number} - тип: #{train.type}, количество вагонов: #{train.wagons.length}"
          show_wagons(train)
          puts delimiter
        end
      end
      puts bold_delimiter
    end
  end
end

rr = RealRailways.new

rr.seed

rr.start
