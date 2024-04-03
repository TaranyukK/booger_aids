require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/passenger_train'
require_relative 'trains/cargo_train'
require_relative 'wagons/wagon'
require_relative 'wagons/passenger_wagon'
require_relative 'wagons/cargo_wagon'

class RealRailways
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
        puts "До свидания!"
        return
      else
        puts wrong_attribute
      end
    end
  end

  def seed
    #stations
    print 'Stations...'
    10.times { stations << Station.new(rand(1000)) }
    sleep(1)
    puts 'OK'

    #routes
    print 'Routes...'
    20.times do
      route = Route.new(stations.sample, stations.sample)
      (rand(3..7)).times { route.add_station(stations.sample) }
      routes << route
    end
    sleep(1)
    puts 'OK'

    #pass trains
    print 'Passenger trains...'
    10.times do
      train = PassengerTrain.new(rand(1000))
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end
    sleep(1)
    puts 'OK'

    #cargo trains
    print 'Cargo trains...'
    10.times do
      train = CargoTrain.new(rand(1000))
      train.take_route(routes.sample)
      stations.sample.train_arrival(train)
      trains << train
    end
    sleep(1)
    puts 'OK'

    #wagons
    print 'Wagons...'
    trains.each do |train|
      if train.type == :passenger
        10.times { train.add_wagon(PassengerWagon.new(rand(1000))) }
      else
        10.times { train.add_wagon(CargoWagon.new(rand(1000))) }
      end
    end
    sleep(1)
    puts 'OK'
  end

  private

  MENU = ['База поездов', 'База маршрутов и станций', 'Список станций и поездов', 'Выход'].freeze

  def menu
    show_items(MENU)
    get_answer_i
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

  TRAINS_MENU = ['Создать поезд', 'Выбрать поезд', 'В главное меню'].freeze

  def all_trains_menu
    show_items(TRAINS_MENU)
    get_answer_i
  end

  def trains_configure(train)
    loop do
      case trains_configure_menu
      when 1
        add_wagon_to_train(train)
      when 2
        remove_wagon_from_train(train)
      when 3
        add_route_to_train(train)
      when 4
        train.move_next
      when 5
        train.move_prev
      when 6
        break
      else
        puts wrong_attribute
      end
    end
  end

  TRAINS_CONFIGURE_MENU = [
    'Добавить вагон в поезд',
    'Удалить вагон из поезда',
    'Назначить маршрут поезду',
    'Переместить поезд вперед',
    'Переместить поезд назад',
    'В главное меню'
  ].freeze

  def trains_configure_menu
    show_items(TRAINS_CONFIGURE_MENU)
    get_answer_i
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

  ROUTES_AND_STATIONS_MENU = [
    'Создать станцию',
    'Создать маршрут',
    'Добавить станцию в маршрут',
    'Удалить станцию из маршрута',
    'Посмотреть все маршруты и станции',
    'В главное меню'
  ].freeze

  def routes_and_stations_menu
    show_items(ROUTES_AND_STATIONS_MENU)
    get_answer_i
  end

  def stations_and_trains
    stations.each do |station|
      puts "Станция: #{station.name}"
      unless station.trains.empty?
        puts 'Поезда:'
        station.trains.each { |train| puts "№ #{train.number}" }
      else
        puts 'У станции нет поездов!'
      end
    end
  end

  # action methods
  def create_train
    puts 'Создание поезда'
    puts 'Введите номер поезда:'
    train_number = get_answer
    loop do
      puts 'Введите тип поезда 1 - пассажирский, 2 - грузовой'
      case get_answer_i
      when 1
        trains << PassengerTrain.new(train_number)
        return
      when 2
        trains << CargoTrain.new(train_number)
        return
      else
        puts wrong_attribute
      end
    end
  end

  def choose_train
    puts 'Выберите поезд:'
    trains.each_with_index { |train, index| puts "#{index}. #{train.type == :passenger ? 'Пассажирский' : 'Грузовой'} поезд №#{train.number}" }
    loop do
      answer = get_answer_i
      trains[answer] ? (return trains[answer]) : (puts wrong_attribute)
    end
  end

  def choose_wagon(train)
    puts 'Выберите вагон:'
    train.wagons.each_with_index { |wagon, index| puts "#{index}. Вагон №#{wagon.number}" }
    loop do
      answer = get_answer_i
      train.wagons[answer] ? (return train.wagons[answer]) : (puts wrong_attribute)
    end
  end

  def choose_route
    puts 'Выберите маршрут:'
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name}--#{route.last_station.name}" }
    loop do
      answer = get_answer_i
      routes[answer] ? (return routes[answer]) : (puts wrong_attribute)
    end
  end

  def add_wagon_to_train(train)
    puts 'Введите номер вагона:'
    wagon_number = get_answer
    new_wagon = train.type == :passenger ? PassengerWagon.new(wagon_number) : CargoWagon.new(wagon_number)
    wagons << new_wagon
    train.wagons << new_wagon
  end

  def remove_wagon_from_train(train)
    wagon = choose_wagon(train)
    train.remove_wagon(wagon)
  end

  def add_route_to_train(train)
    route  = choose_route
    train.take_route(route)
  end

  def create_station
    puts 'Создание станции'
    puts 'Введите название станции:'
    station_name = get_answer.chomp
    stations << Station.new(station_name)
  end

  def create_route
    puts 'Создание машрута'
    all_stations
    puts 'Введите начальную станцию:'
    first_station = get_answer_i
    puts 'Введите конечную станцию:'
    last_station = get_answer_i
    if stations[first_station] && stations[last_station]
      routes << Route.new(first_station, last_station)
    else
      puts wrong_attribute
    end
  end

  def add_station_to_route
    puts 'Выберите маршрут'
    routes.each_with_index { |route, index| puts "#{index}. #{route.first_station.name} -- #{route.last_station.name}" }
    loop do
      answer = get_answer_i
      if routes[answer]
        route = routes[answer]
        puts 'Выберите станцию для добавления:'
        all_stations(stations - route.stations)
        station_index = get_answer_i
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
      answer = get_answer_i
      if routes[answer]
        route = routes[answer]
        puts 'Выберите станцию для удаления:'
        all_stations(route.stations)
        station_index = get_answer_i
        if route.stations[stations_index]
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
      puts delimiter
    end
  end

  def all_stations(stations = self.stations)
    stations.each_with_index { |station, index | puts "#{index}. №#{station.name}" }
  end

  # helpers
  def show_items(items)
    items.each_with_index { |item, index| puts "#{index+1}. #{item}" }
  end

  def get_answer
    gets.chomp
  end

  def get_answer_i
    gets.to_i
  end

  def wrong_attribute
    'Неверное значение, попробуйте еще раз!'
  end

  def delimiter
    '--------------------------------------'
  end
end
