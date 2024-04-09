class CargoWagon < Wagon
  attr_reader :type, :space, :free_space

  def initialize(number, space)
    @type = :cargo
    @space = space
    @free_space = space
    super(number)
  end

  def fill_space(volume)
    free_space!(volume)
  end

  def occupied_space
    space - free_space
  end

  private

  attr_writer :free_space

  def free_space!(volume)
    self.free_space -= volume if free_space.positive?
  end
end
