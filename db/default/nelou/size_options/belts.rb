# Standard Sizes: Belts

## International Standard

intl = {}

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Belts, International') do |type|
  type.name = 'Size - Belts, International'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Belts, International', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Gürtel, International', presentation: 'Größe', locale: 'de' }
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

## European Standard

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Belts, Europe') do |type|
  type.name = 'Size - Belts, Europe'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Belts, Europe', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Gürtel, Europa', presentation: 'Größe', locale: 'de' }
type.save!

%w(65 70 75 80 85 90 95 100 105).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.left_conversions.clear
  s = size.to_i
  if s <= 70
    value.left_conversions << intl[:XXS]
  end
  if s >= 70 && s <= 75
    value.left_conversions << intl[:XS]
  end
  if s >= 75 && s <= 80
    value.left_conversions << intl[:S]
  end
  if s >= 80 && s <= 85
    value.left_conversions << intl[:M]
  end
  if s >= 85 && s <= 90
    value.left_conversions << intl[:L]
  end
  if s >= 90 && s <= 95
    value.left_conversions << intl[:XL]
  end
  if s >= 95 && s <= 100
    value.left_conversions << intl[:XXL]
  end
  if s >= 100
    value.left_conversions << intl[:XXXL]
  end

  value.presentation = size
  value.position = i + 1
  value.save!
end
