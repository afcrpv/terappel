class ApplicationDecorator < Draper::Decorator
  def twipsy(value)
    h.content_tag :a, h.truncate(value, length: 20),
      href: "#", data: {toggle: "tooltip"},
      title: value
  end

  def localize_date(datefield)
    h.l datefield
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
