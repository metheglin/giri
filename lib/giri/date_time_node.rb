require "date"

class Giri::DateTimeNode < DelegateClass(DateTime)
  extend Giri::Bud

  def initialize(node)
    @node = node
    @attributes = Hashie::Mash.new(build_attributes)
    super(DateTime.parse(@node.text))
  end
end
