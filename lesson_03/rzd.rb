class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def train_arrival(train)
    trains << train
  end

  def trains_by_types
    trains.map(&:type).tally
  end

  def train_departure(train)
    trains.delete(train)
  end
end

class Route
  attr_reader :first_station, :last_station, :way_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @way_stations = []
  end

  def add_station(station)
    way_stations << station
  end

  def remove_station(station)
    way_stations.delete(station)
  end

  def stations
    [first_station, way_stations, last_station].flatten
  end
end

class Train
  attr_accessor :speed
  attr_reader :type, :wagons

  TYPES = [:passenger, :freight]

  def initialize(number, type, wagons)
    @number = number
    @type = TYPES[type]
    @wagons = wagons
    @speed = 0
  end

  def move(speed)
    self.speed = speed
  end

  def stop
    self.speed = 0
  end

  def add_wagon
    self.wagons += 1 if speed.zero?
  end

  def remove_wagon
    self.wagons -= 1 if speed.zero? && wagons > 0
  end

  def take_route(route)
    @route = route
    @current_index = 0
    route.stations[0].train_arrival(self)
  end

  def current_index
    @current_index
  end

  def current_station
    return unless @route
    @route.stations[@current_index]
  end

  def next_station
    return unless @route
    @route.stations[@current_index + 1]
  end

  def previous_station
    return unless @route && !(@current_index < 1)
    @route.stations[@current_index - 1]
  end

  def move_next
    return unless @route && next_station
    current_station.train_departure(self)
    @current_index += 1
    current_station.train_arrival(self)
  end

  def move_prev
    return unless @route && previous_station
    current_station.train_departure(self)
    @current_index -= 1
    current_station.train_arrival(self)
  end
end