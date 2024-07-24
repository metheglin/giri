require "date"

class Giri::TextNodeDateTime < DelegateClass(DateTime)
  extend Giri::Bud

  def self.build_value(str)
    DateTime.parse(str)
  end

  def initialize(*args)
    initialize_setup(*args)
    super(self.class.build_value(@node.text))
  end
end
