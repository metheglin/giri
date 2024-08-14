class Giri::Context
  def initialize(base_node)
    @base_node = base_node
    @context_attributes = base_node.class.context_attributes
  end

  def method_missing(method, *args, &block)
    if @context_attributes.include?(method.to_sym)
      @base_node.public_send(method, *args, &block)
    else
      if @base_node.parent
        @base_node.parent.context.public_send(method, *args, &block)
      else
        super
      end
    end
  end
end
