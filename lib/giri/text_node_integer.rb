class Giri::TextNodeInteger < DelegateClass(Integer)
  extend Giri::Bud

  def self.build_value(str)
    str.to_i
  end

  def initialize(node)
    @node = node
    @attributes = Hashie::Mash.new(build_attributes)
    super(self.class.build_value(@node.text))
  end
end
