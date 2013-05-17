class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def twipsy(value)
    content_tag :a, truncate(value, length: 20),
      href: "#", rel: "tooltip",
      "data-original-title" => value
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

  def localize_date(datefield)
    l datefield
  end

  def array_to_hash(a)
    h = {}
    a.each do |m,n|
      h[n] = m
    end
    return h
  end

  def handle_none(value, message="-")
    if value.present?
      yield
    else
      message
    end
  end
end
