# Standard Sizes: Men

## Men's

### International Standard

intl = {}

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Men, International') do |type|
  type.name = 'Size - Men, International'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Men, International', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Herrenbekleidung, International', presentation: 'Größe', locale: 'de' }
type.save!

%w(XS S M L XL XXL 3XL 4XL).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.presentation = size
  value.position = i + 1
  value.save!

  intl[size.to_sym] = value
end

### German Standard

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Men, Germany') do |type|
  type.name = 'Size - Men, Germany'
  type.presentation = 'Size'
  type.country_code = 'DE'
end

type.attributes = { name: 'Size - Men, Germany', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Herrenbekleidung, Deutschland', presentation: 'Größe', locale: 'de' }
type.save!

%w(44 46 48 50 52 54 56 58 60).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.left_conversions.clear
  s = size.to_i
  if s == 44
    value.left_conversions << intl[:XS]
  end
  if s == 46
    value.left_conversions << intl[:S]
  end
  if s == 48
    value.left_conversions << intl[:M]
  end
  if s == 50
    value.left_conversions << intl[:M]
    value.left_conversions << intl[:L]
  end
  if s == 52
    value.left_conversions << intl[:L]
  end
  if s == 54
    value.left_conversions << intl[:XL]
  end
  if s == 56
    value.left_conversions << intl[:XXL]
  end
  if s == 58
    value.left_conversions << intl[:'3XL']
  end
  if s == 60
    value.left_conversions << intl[:'4XL']
  end

  value.presentation = size
  value.position = i + 1
  value.save!
end
