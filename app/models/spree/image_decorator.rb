Spree::Image.class_eval do
  include Nelou::HasCustomFileName
  include Nelou::AttachmentFromUrl

  allow_from_url :attachment

  has_custom_file_name :attachment, :generate_hex_for_file_name

  attachment_definitions[:attachment][:styles] = {
    mini: '50x75>',
    mini_2x: '100x150>',
    small: '150x225>',
    small_2x: '300x450>',
    product: '300x450>',
    product_2x: '600x900>',
    large: '1000x1500>',
    large_2x: '2000x3000>'
  }
end
