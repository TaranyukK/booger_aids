class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    puts "Станция #{name} создана!"
  end

  def train_arrival(train)
    trains << train
    puts "#{train.type_human.capitalize} поезд №#{train.number} добавлен на станцию!"
  end

  def trains_by_types
    puts 'На станции:'
    trains.map(&:type_human).tally.each { |k, v| puts "#{k}: #{v}" }
  end

  def train_departure(train)
    trains.delete(train)
    puts "#{train.type_human.capitalize} поезд №#{train.number} удален со станции!"
  end
end