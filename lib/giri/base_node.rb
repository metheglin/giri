class Giri::BaseNode
  extend Giri::Bud

  def inspect
    "#<#{self.class}:0x#{object_id.to_s(16)} @ref_name=#{@ref_name.inspect} parent_ref_name=#{parent_ref_name.inspect} @attributes=#{@attributes.inspect}>"
  end
end
