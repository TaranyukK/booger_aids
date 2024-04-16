class Route
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :first_station, :last_station, :way_stations

  validate :first_station, :presence
  validate :first_station, :type, Station
  validate :second_station, :presence
  validate :last_station, :type, Station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @way_stations = []
    validate!
    puts "1 - #{first_station.name}; 2 - #{last_station.name}"
    register_instance
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
    raise 'Начальная станция не может быть пустой!' if first_station.nil?
    raise 'Конечная станция не может быть пустой!' if last_station.nil?
  end
end
