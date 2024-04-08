module Validation
  def valid?
    self.validate!
  rescue
    false
  end
end
