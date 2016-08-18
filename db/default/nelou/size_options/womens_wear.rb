# Standard Sizes: Women

## Women's

### International Standard

intl = {}

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Women, International') do |type|
  type.name = 'Size - Women, International'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Women, International', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Damenbekleidung, International', presentation: 'Größe', locale: 'de' }
type.save!

%w(XXS XS S M L XL XXL XXXL).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.presentation = size
  value.position = i + 1
  value.save!

  intl[size.to_sym] = value
end

### German Standard

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Women, Germany') do |type|
  type.name = 'Size - Women, Germany'
  type.presentation = 'Size'
  type.country_code = 'DE'
end

type.attributes = { name: 'Size - Women, Germany', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Damenbekleidung, Deutschland', presentation: 'Größe', locale: 'de' }
type.save!

%w(30 32 34 36 38 40 42 44 46).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.left_conversions.clear
  s = size.to_i
  if s <= 32
    value.left_conversions << intl[:XXS]
  end
  if s >= 32 && s <= 34
    value.left_conversions << intl[:XS]
  end
  if s >= 34 && s <= 36
    value.left_conversions << intl[:S]
  end
  if s >= 36 && s <= 38
    value.left_conversions << intl[:M]
  end
  if s >= 38 && s <= 40
    value.left_conversions << intl[:L]
  end
  if s >= 40 && s <= 42
    value.left_conversions << intl[:XL]
  end
  if s >= 42 && s <= 44
    value.left_conversions << intl[:XXL]
  end
  if s >= 44
    value.left_conversions << intl[:XXXL]
  end

  value.presentation = size
  value.position = i + 1
  value.save!
end
