Spree::BaseHelper.class_eval do
  def logo(image_path = Spree::Config[:logo], options = {})
    link_to image_tag(image_path), spree.root_path, options
  end

  private

  def create_product_image_tag(image, product, options, style)
    options.reverse_merge! alt: image.alt.blank? ? product.name : image.alt
    options.reverse_merge! srcset: "#{image.attachment.url(style + '_2x')} 2x" if image.attachment.exists?(style + '_2x')
    options.reverse_merge! 'data-large': image.attachment.url(:large) if image.attachment.exists?('large')
    image_tag image.attachment.url(style), options
  end

  # Because the form in Spree_I18n doesn't like namespaced routes
  def admin_nelou_size_option_type_path(resource)
    main_app.admin_nelou_size_option_type_path(resource)
  end

  # Because the form in Spree_I18n doesn't like namespaced routes
  def admin_option_type_nelou_size_option_value_path(resource)
    main_app.admin_nelou_size_option_type_nelou_size_option_value_path(resource.option_type, resource)
  end
end
