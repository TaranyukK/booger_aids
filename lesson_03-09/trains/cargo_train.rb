class CargoTrain < Train
  attr_reader :type

  @trains = {}

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  def initialize(number)
    super
    @type = :cargo
  end
end
