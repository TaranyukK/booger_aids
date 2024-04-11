class Station
  include InstanceCounter
  include Validation
  include Accessors

  attr_reader :name, :trains

  @@stations = []

  validate :name, :presence
  validate :name, :format, /^[a-z0-9]{5}$/i

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
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

  def each_train(&block)
    trains.each(&block) if block_given?
  end

  private

  def validate!
    raise 'Длинна названия должна быть минимум 5 символов!' if name.length < 5
  end
end
