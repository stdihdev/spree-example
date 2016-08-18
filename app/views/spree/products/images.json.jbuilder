json.(@product, :id, :name)
json.label @product.designer_label.name
json.link 'javascript:void(0)'
json.link_text 'Zum Produkt'
json.images @product.images do |image|
  json.id image.id
  json.width image.attachment_width
  json.height image.attachment_height
  json.contentType image.attachment_content_type
  %i(original product product_2x large large_2x mini mini_2x).each do |size|
    json.set! size, image.attachment.url(size)
  end
end
