class Train
  attr_reader :number, :type, :wagons, :speed, :route

  TYPES = [:passenger, :cargo]

  def initialize(number, type)
    @number = number
    @type = TYPES[type]
    @wagons = []
    @speed = 0
  end

  def move(speed)
    move!(speed)
    puts "Поезд набирает скорость: #{speed}!"
  end

  def stop
    stop!
    puts 'Поезд остановился!'
  end

  def add_wagon(wagon)
    return unless wagon_suitable?(wagon)
    wagons << wagon if speed.zero?
    puts "Вагон №#{wagon.number} добавлен в поезд!"
  end

  def remove_wagon(wagon)
    return unless wagon_suitable?(wagon)
    wagons.delete(wagon) if speed.zero? && !(wagons.empty?)
    puts "Вагон №#{wagon.number} удален из поезда!"
  end

  def take_route(route)
    self.route = route
    self.current_index = 0
    route.stations[0].train_arrival(self)
    puts "Поезд взял маршрут: #{route.first_station} -- #{route.last_station}"
  end

  def current_station
    return unless current_station!
    puts "Текущая станция - #{current_station!.name}"
  end

  def next_station
    return unless next_station!
    puts "Следующая станция - #{next_station!.name}"
  end

  def previous_station
    return unless previous_station!
    puts "Предыдущая станция - #{previous_station!.name}"
  end

  def move_next
    move_next!(self) if next_station!
    puts "Поезд приехал на станцию #{previous_station!.name}"
  end

  def move_prev
    move_prev!(self) if previous_station!
    puts "Поезд приехал на станцию #{previous_station!.name}"
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

  def move_next!(train)
    current_station!.train_departure(train)
    self.current_index += 1
    current_station!.train_arrival(train)
  end

  def move_prev!(train)
    current_station!.train_departure(train)
    self.current_index -= 1
    current_station!.train_arrival(train)
  end

  def wagon_suitable?(wagon)
    self.type == wagon.type
  end
end