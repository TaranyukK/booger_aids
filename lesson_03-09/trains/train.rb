class Train
  include Manufactor
  include InstanceCounter
  include Validation
  include Accessors

  NUMBER_FORMAT = /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i.freeze

  attr_reader :number, :type, :wagons, :speed, :route

  attr_accessor_with_history :number
  strong_attr_accessor :number, String

  validate :number, :presence

  class << self
    attr_reader :trains

    def find(number)
      @trains[number]
    end
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    validate!
    self.class.trains[number] = self
    register_instance
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

    wagons.delete(wagon) if speed.zero? && !wagons.empty?
  end

  def take_route(route)
    self.route = route
    self.current_index = 0
    route.stations[0].train_arrival(self)
  end

  def current_station
    nil unless current_station!
  end

  def next_station
    nil unless next_station!
  end

  def previous_station
    nil unless previous_station!
  end

  def move_next
    move_next! if next_station!
  end

  def move_prev
    move_prev! if previous_station!
  end

  def each_wagon(&block)
    wagons.each(&block) if block_given?
  end

  def passenger?
    type == :passenger
  end

  private

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
    type == wagon.type
  end
end
