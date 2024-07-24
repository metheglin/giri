class Giri::TextNodeString < DelegateClass(String)
  extend Giri::Bud

  def initialize(*args)
    initialize_setup(*args)
    super(@node.text)
  end
end
