# Standard Sizes: Gloves

# International Standard

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Gloves') do |type|
  type.name = 'Size - Gloves'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Gloves', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Handschuhe', presentation: 'Größe', locale: 'de' }
type.save!

%w(XS S M L XL).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.presentation = size
  value.position = i + 1
  value.save!
end
