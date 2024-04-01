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
      when 0
        puts "До свидания!"
        return
      when 1
        all_trains
      when 2
        routes_and_stations
      when 3
        stations_and_trains
      else
        puts wrong_attribute
        start
      end
    end
  end

  private

  # menu methods
  def menu
    puts '1. База поездов'
    puts '2. База маршрутов и станций'
    puts '3. Список станций и поездов'
    puts '0. Выход'
    get_answer_i
  end

  def all_trains
    case all_trains_menu
    when 0
      start
    when 1
      create_train
    when 2
      trains_routng(choose_train)
    else
      puts wrong_attribute
      all_trains_menu
    end
  end

  def all_trains_menu
    puts '1. Создать поезд'
    puts '2. Выбрать поезд'
    puts '0. В главное меню'
    get_answer_i
  end

  def trains_routing(train)
    case trains_routing_menu
    when 0
      start
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
    else
      puts wrong_attribute
      trains_routing_menu
    end
  end

  def trains_routing_menu
    puts '1. Добавить вагон в поезд'
    puts '2. Удалить вагон из поезда'
    puts '3. Назначить маршрут поезду'
    puts '4. Переместить поезд вперед'
    puts '5. Переместить поезд назад'
    puts '0. В главное меню'
    get_answer_i
  end

  def routes_and_stations
    case routes_and_stations_menu
    when 0
      start
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
    else
      puts wrong_attribute
      routes_and_stations_menu
    end
  end
  def routes_and_stations_menu
    puts '1. Создать станцию'
    puts '2. Создать маршрут'
    puts '3. Добавить станцию в маршрут'
    puts '4. Удалить станцию из маршрута'
    puts '5. Посмотреть все маршруты и станции'
    puts '0. В главное меню'
    get_answer_i
  end

  def stations_and_trains
    stations.each do |station|
      puts station.name
      puts 'Поезда:'
      station.trains.each { |train| puts "№ #{train.number}" }
    end
  end

  # action methods
  def create_train
    puts 'Создание поезда'
    puts 'Введите номер поезда:'
    train_number = get_answer.chomp
    loop do
      puts 'Введите тип поезда 1 - пассажирский, 2 - грузовой'
      case get_answer_i
      when 1
        trains << PassengerTrain.new(train_number, 0)
        return
      when 2
        trains << CargoTrain.new(train_number, 1)
        return
      else
        puts wrong_attribute
      end
    end
  end

  def choose_train
    puts 'Выберите поезд:'
    trains.each_with_index { |train, index| puts "#{index}. #{train.type == Train::TYPES[0] ? 'Пассажирский' : 'Грузовой'} поезд №#{train.number}" }
  end

  def add_wagon_to_train
    choose_train
    loop do
      answer = get_answer_i
      if trains[answer]
        puts 'Введите номер вагона:'
        wagon_number = get_answer
        case trains[answer].type
        when :passenger
          new_wagon = PassengerWagon.new(wagon_number, 0)
        else
          new_wagon = CargoWagon.new(wagon_number, 0)
        end
        wagons << new_wagon
        trains[answer].wagons << new_wagon
      else
        puts wrong_attribute
      end
    end
  end

  def remove_wagon_from_train

  end

  def add_route_to_train
    puts __method__.to_s
  end

  def move_train_next
    puts __method__.to_s
    nil
  end

  def move_train_prev
    puts __method__.to_s
    nil
  end

  def create_station
    puts 'Создание станции'
    puts 'Введите название станции:'
    station_name = get_answer.chomp
    stations << Station.new(station_name)
    nil
  end

  def create_route
    puts 'Создание машрута'
    nil
  end

  def add_station_to_route
    puts __method__.to_s
    nil
  end

  def remove_station_from_route
    puts __method__.to_s
    nil
  end

  def show_stations_and_routes
    routes.each do |route|
      puts "#{route.first_station} -- #{route.last_station}"
      puts 'Станции:'
      all_stations(route.stations)
      puts delimiter
    end
    nil
  end

  def all_stations(stations = self.stations)
    stations.each { |station| puts station.name }
    nil
  end

  # helpers
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
