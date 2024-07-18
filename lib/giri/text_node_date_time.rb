require "date"

class Giri::TextNodeDateTime < DelegateClass(DateTime)
  extend Giri::Bud

  def self.build_value(str)
    DateTime.parse(str)
  end

  def initialize(node)
    @node = node
    @attributes = Hashie::Mash.new(build_attributes)
    super(self.class.build_value(@node.text))
  end
end
