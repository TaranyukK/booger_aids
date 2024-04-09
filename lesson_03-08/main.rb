require_relative 'modules/manufactor'
require_relative 'modules/constant'
require_relative 'modules/helper'
require_relative 'modules/validation'
require_relative 'modules/instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/passenger_train'
require_relative 'trains/cargo_train'
require_relative 'wagons/wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'wagons/cargo_wagon'

class RealRailways
  include Constant
  include Helper

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
      case menu
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
    # stations
    10.times { stations << Station.new(rand(10_000..99_999).to_s) }

    # routes
    20.times do
      route = Route.new(stations.sample, stations.sample)
      rand(3..7).times { route.add_station(stations.sample) }
      routes << route
    end

    # pass trains
    10.times do
      train = PassengerTrain.new(rand(100..1000).to_s)
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end

    # cargo trains
    10.times do
      train = CargoTrain.new(rand(100..1000).to_s)
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end

    # wagons
    trains.each do |train|
      if train.passenger?
        10.times { train.add_wagon(PassengerWagon.new(rand(10_000..99_999).to_s, rand(10..50))) }
      else
        10.times { train.add_wagon(CargoWagon.new(rand(10_000..99_999).to_s, rand(100..500))) }
      end
    end
    puts 'OK'
  end

  private

  def menu
    show_items(MENU)
    answer_i
  end

  def all_trains
    loop do
      case all_trains_menu
      when 1
        create_train
      when 2
        train = choose_train
        trains_configure(train)
      when 3
        break
      else
        puts wrong_attribute
      end
    end
  end

  def all_trains_menu
    show_items(TRAINS_MENU)
    answer_i
  end

  def trains_configure(train)
    loop do
      case trains_configure_menu
      when 1
        show_wagons(train)
      when 2
        wagon = choose_wagon(train)
        wagon_configure(wagon)
      when 3
        add_wagon_to_train(train)
      when 4
        remove_wagon_from_train(train)
      when 5
        add_route_to_train(train)
      when 6
        train.move_next
      when 7
        train.move_prev
      when 8
        break
      else
        puts wrong_attribute
      end
    end
  end

  def trains_configure_menu
    show_items(TRAINS_CONFIGURE_MENU)
    answer_i
  end

  def routes_and_stations
    loop do
      case routes_and_stations_menu
      when 1
        create_station
      when 2
        create_route
      when 3
        add_station_to_route
      when 4
        remove_station_from_route
      when 5
        show_stations_and_routes
      when 6
        break
      else
        puts wrong_attribute
      end
    end
  end

  def routes_and_stations_menu
    show_items(ROUTES_AND_STATIONS_MENU)
    answer_i
  end

  def wagon_configure(wagon)
    loop do
      case wagon_configure_menu(wagon)
      when 1
        if wagon.passenger?
          wagon.take_seat
        else
          puts 'Введите объем'
          value = answer_i
          wagon.fill_space(value)
        end
      when 2
        break
      else
        puts wrong_attribute
      end
    end
  end

  def wagon_configure_menu(wagon)
    puts "1. #{WAGON_CONFIGURE_MENU.first[wagon.type]}"
    puts "2. #{WAGON_CONFIGURE_MENU.last}"
    answer_i
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
    puts 'Выберите поезд:'
    trains.each_with_index do |train, index|
      puts "#{index}. #{train.passenger? ? 'Пассажирский' : 'Грузовой'} поезд №#{train.number}"
    end
    loop do
      answer = answer_i
      trains[answer] ? (return trains[answer]) : (puts wrong_attribute)
    end
  end

  def choose_wagon(train)
    puts 'Выберите вагон:'
    train.wagons.each_with_index do |wagon, index|
      puts "#{index}. Вагон №#{wagon.number} - свободно: #{wagon.passenger? ? wagon.free_seats : wagon.free_space}"
    end
    loop do
      answer = answer_i
      train.wagons[answer] ? (return train.wagons[answer]) : (puts wrong_attribute)
    end
  end

  def choose_route
    puts 'Выберите маршрут:'
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name}--#{route.last_station.name}" }
    loop do
      answer = answer_i
      routes[answer] ? (return routes[answer]) : (puts wrong_attribute)
    end
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
                  else
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
    puts 'Создание машрута'
    all_stations
    puts 'Введите начальную станцию:'
    first_station = answer_i
    puts 'Введите конечную станцию:'
    last_station = answer_i
    if stations[first_station] && stations[last_station]
      routes << Route.new(stationss[first_station], stations[last_station])
    else
      puts wrong_attribute
    end
  end

  def add_station_to_route
    puts 'Выберите маршрут'
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name} -- #{route.last_station.name}" }
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
    puts 'Выберите маршрут'
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name} -- #{route.last_station.name}" }
    loop do
      answer = answer_i
      if routes[answer]
        route = routes[answer]
        puts 'Выберите станцию для удаления:'
        all_stations(route.stations)
        station_index = answer_i
        if route.stations[station_index]
          route.remove_station(route.stations[stations_index])
          return
        else
          puts wrong_attribute
        end
      else
        puts wrong_attribute
      end
    end
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
end

rr = RealRailways.new

rr.seed

rr.start
