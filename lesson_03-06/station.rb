class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    self.register_instance
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

  private
  def validate!
    raise 'Длинна названия должна быть минимум 5 символов!' if name.length < 5
  end
end
