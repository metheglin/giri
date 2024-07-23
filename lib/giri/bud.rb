module Giri::Bud

  def self.extended(base)
    base.singleton_class.attr_accessor :xml_nodes, :xml_attributes, :with_name_default_for_node, :with_name_default_for_attribute
    
    base.xml_nodes = {}
    base.xml_attributes = []
    # TODO: Set nil for default
    base.with_name_default_for_node = :camelize
    base.with_name_default_for_attribute = :lower_camelcase

    base.class_eval do
      attr_reader :node, :attributes
      def initialize(node)
        @node = node
        @attributes = Hashie::Mash.new(build_attributes)
      end

      def find_elements(name)
        node.elements.select{|e| e.name == name}
      end

      def find_element(name)
        node.elements.find{|e| e.name == name}
      end

      def where(&block)
        block.call(node)
      end

      def build_attributes
        self.class.xml_attributes.map do |col|
          name = col[:name]
          type = self.class.build_type(col[:type])
          with_name = col[:with_name]

          attr_name = self.class.build_attribute_name(name, with_name || self.class.with_name_default_for_attribute)
          value = node.attributes[attr_name.to_s]&.value
          value = if value
            if type.is_a?(Class)
              type.new(value)
            elsif type.is_a?(Symbol)
              "Giri::TextNode#{type.to_s.camelize}".constantize.build_value(value)
            else
              value
            end
          else
            value
          end
          # value = (value && type) ? type.new(value) : value

          [name.to_sym, value]
        end.to_h
      end
    end
  end

  def inherited(base)
    base.xml_nodes = xml_nodes.dup
    base.xml_attributes = xml_attributes.dup
    base.with_name_default_for_node = with_name_default_for_node
    base.with_name_default_for_attribute = with_name_default_for_attribute
    super
  end

  def spawn(&block)
    Class.new(self, &block)
  end

  def text_node(name, **args, &block)
    xml_node(name, type: "Giri::TextNodeString", **args, &block)
  end

  def integer_node(name, **args, &block)
    xml_node(name, type: "Giri::TextNodeInteger", **args, &block)
  end

  def big_decimal_node(name, **args, &block)
    xml_node(name, type: "Giri::TextNodeBigDecimal", **args, &block)
  end

  def date_time_node(name, **args, &block)
    xml_node(name, type: "Giri::TextNodeDateTime", **args, &block)
  end

  def duration_node(name, **args, &block)
    xml_node(name, type: "Giri::TextNodeDuration", **args, &block)
  end

  def xml_node_collection(name, **args, &block)
    xml_node(name, collection: true, **args, &block)
  end

  def xml_node(name, type: nil, collection: nil, where: nil, with_name: nil, &block)
    type = if block_given?
      type = build_type(type || self.xml_nodes.dig(name.to_sym, :type) || "Giri::BaseNode")
      type.spawn(&block)
    else
      build_type(type)
    end

    self.xml_nodes[name.to_sym] = {name: name, type: type, collection: collection}

    class_eval do
      define_method(name) do
        var = instance_variable_get("@#{name}")
        var || begin
          attr_name = self.class.build_attribute_name(name, with_name || self.class.with_name_default_for_node)
          elem = if where
            where.call(node)
          else
            collection ?
              find_elements(attr_name.to_s) :
              find_element(attr_name.to_s)
          end
          elem = if collection
            elem.empty? ? nil : elem
          else
            elem
          end

          if elem
            # type = if block_given? # This block points the args in `xml_node` not method defined dynamically.
            #   type = self.class.build_type(type || "Giri::BaseNode")
            #   type.spawn(&block)
            # else
            #   self.class.build_type(type)
            # end
            o = if collection
              elem.map{|e| type ? type.new(e) : e}
            else
              type ? type.new(elem) : elem
            end
            instance_variable_set("@#{name}", o)
          end
        end
      end
    end
  end

  def xml_attribute(name, **args)
    self.xml_attributes = self.xml_attributes.append(args.merge(name: name))
    
    class_eval do
      define_method(name) do
        attributes.public_send(name)
      end
    end
  end

  def build_attribute_name(name, with_name)
    if with_name.is_a?(String)
      with_name
    elsif [:underscore, :camelize, :camelcase].include?(with_name)
      name.to_s.send(with_name).to_sym
    elsif with_name == :lower_camelcase
      name.to_s.camelize(:lower).to_sym
    else
      name
    end
  end

  def build_type(type)
    if type.is_a?(Class)
      type
    elsif type.is_a?(String)
      # type.to_s.constantize
      Object.const_get(type.to_s)
    elsif type.is_a?(Symbol)
      type
    else
      nil
    end
  end
end
