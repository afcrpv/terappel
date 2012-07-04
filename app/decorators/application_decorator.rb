#encoding: utf-8
class ApplicationDecorator < Draper::Base

  def localize_date(datefield)
    h.l datefield
  end

  def handle_none(value, message="-")
    if value.present?
      yield
    else
      message
    end
  end

  def twipsy(value)
    h.content_tag :a, h.truncate(value, length: 20),
      href: "#", rel: "tooltip",
      "data-original-title" => value
  end

  def array_to_hash(a)
    h = {}
    a.each do |m,n|
      h[n] = m
    end
    return h
  end
end
