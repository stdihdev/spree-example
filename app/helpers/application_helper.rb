module ApplicationHelper

  def space
    '&nbsp;'.html_safe
  end

  def og_meta_tag(property, content)
    tag('meta', property: "og:#{property}", content: content)
  end

  def property_meta_tag(property, content)
    tag('meta', property: property, content: content)
  end

end
