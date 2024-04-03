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
