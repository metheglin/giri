class Giri::TextNodeString < DelegateClass(String)
  extend Giri::Bud

  def initialize(node)
    @node = node
    @attributes = Hashie::Mash.new(build_attributes)
    super(@node.text)
  end
end
