class Route
  attr_reader :first_station, :last_station, :way_stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @way_stations = []
    puts "Маршрут #{@first_station.name}--#{@last_station.name} создан!"
  end

  def add_station(station)
    way_stations << station
    puts "Станция #{station.name} добавлена!"
  end

  def remove_station(station)
    way_stations.delete(station)
    puts "Станция #{station.name} удалена!"
  end

  def stations
    [first_station, way_stations, last_station].flatten
  end
end