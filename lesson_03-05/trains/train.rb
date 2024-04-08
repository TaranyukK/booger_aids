class Train
  include Manufactor
  include InstanceCounter
  include Validation

  attr_reader :number, :type, :wagons, :speed, :route

  NUMBER_FORMAT = /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i

  class << self
    attr_reader :trains
  end

  def self.find(number)
    @trains[number]
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    validate!
    self.class.trains[number] = self
    self.register_instance
  end

  def move(speed)
    move!(speed)
  end

  def stop
    stop!
  end

  def add_wagon(wagon)
    return unless wagon_suitable?(wagon)
    wagons << wagon if speed.zero?
  end

  def remove_wagon(wagon)
    return unless wagon_suitable?(wagon)
    wagons.delete(wagon) if speed.zero? && !(wagons.empty?)
  end

  def take_route(route)
    self.route = route
    self.current_index = 0
    route.stations[0].train_arrival(self)
  end

  def current_station
    return unless current_station!
  end

  def next_station
    return unless next_station!
  end

  def previous_station
    return unless previous_station!
  end

  def move_next
    move_next! if next_station!
  end

  def move_prev
    move_prev! if previous_station!
  end

  private # Инкапсуляция

  attr_accessor :current_index
  attr_writer :speed, :route

  def move!(speed)
    self.speed = speed
  end

  def stop!
    self.speed = 0
  end

  def current_station!
    return unless route
    route.stations[current_index]
  end

  def next_station!
    return unless route
    route.stations[current_index + 1]
  end

  def previous_station!
    return unless route && current_index.positive?
    route.stations[current_index - 1]
  end

  def move_next!
    current_station!.train_departure(self)
    self.current_index += 1
    current_station!.train_arrival(self)
  end

  def move_prev!
    current_station!.train_departure(self)
    self.current_index -= 1
    current_station!.train_arrival(self)
  end

  def wagon_suitable?(wagon)
    self.type == wagon.type
  end

  def validate!
    raise 'Длинна номера должна быть минимум 3 символа!' if number.length < 3
    raise 'Неверный формат номера!' if number !~ NUMBER_FORMAT
  end
end
