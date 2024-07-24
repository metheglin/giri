require "bigdecimal"
require "bigdecimal/util"

class Giri::TextNodeBigDecimal < DelegateClass(BigDecimal)
  extend Giri::Bud

  def self.build_value(str)
    str.to_d
  end

  def initialize(*args)
    initialize_setup(*args)
    super(self.class.build_value(@node.text))
  end
end
