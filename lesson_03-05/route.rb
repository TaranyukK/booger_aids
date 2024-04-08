class Route
  include InstanceCounter
  include Validation

  attr_reader :first_station, :last_station, :way_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @way_stations = []
    puts "1 - #{first_station.name}; 2 - #{last_station.name}"
    validate!
    self.register_instance
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

  private
  def validate!
    raise 'Начальная и конечная станция не могут совпадать' if first_station == last_station
  end
end
