# https://www.w3.org/TR/xmlschema-2/#duration
class Giri::TextNodeDuration < DelegateClass(Giri::Duration)
  extend Giri::Bud

  def self.build_value(str)
    Giri::Duration.new(str)
  end

  def initialize(*args)
    initialize_setup(*args)
    super(self.class.build_value(@node.text))
  end
end
