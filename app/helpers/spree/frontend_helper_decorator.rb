Spree::FrontendHelper.class_eval do
  def nelou_link_to_cart(link_class = nil)
    if simple_current_order.nil? || simple_current_order.item_count.zero?
      content_tag :span, Spree.t('empty'), class: link_class
    else
      link_to "#{simple_current_order.display_total.to_html} (#{simple_current_order.item_count})".html_safe, spree.cart_path, class: link_class
    end
  end
end
