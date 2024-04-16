class Station
  include InstanceCounter
  include Validation
  include Accessors

  NAME_FORMAT = /^[a-z0-9]{5}$/i.freeze

  attr_reader :name, :trains

  attr_accessor_with_history :name
  strong_attr_accessor :name, String

  validate :name, :presence
  validate :name, :format, NAME_FORMAT
  validate :name, :type, String

  @@stations = []

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
    raise 'Название не может быть пустым!' if name.empty?
    raise 'Длинна названия должна быть минимум 5 символов!' if name.length < 5
    raise 'Неверный формат номера!' if name !~ NAME_FORMAT
  end
end
