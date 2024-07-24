class Giri::TextNodeInteger < DelegateClass(Integer)
  extend Giri::Bud

  def self.build_value(str)
    str.to_i
  end

  def initialize(*args)
    initialize_setup(*args)
    super(self.class.build_value(@node.text))
  end
end
