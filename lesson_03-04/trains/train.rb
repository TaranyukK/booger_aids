class Train
  attr_reader :number, :type, :wagons, :speed, :route

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
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

  attr_accessor :current_index # Пользователю не нужна эта информация
  attr_writer :speed, :route # Запрещаем пользователю напрямую менять атрибуты

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
end
