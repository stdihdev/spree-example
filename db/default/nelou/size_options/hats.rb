# Standard Sizes: Hats

## International Standard

intl = {}

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Hats, International') do |type|
  type.name = 'Size - Hats, International'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Hats, International', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Hüte, International', presentation: 'Größe', locale: 'de' }
type.save!

%w(XS S M L XL).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.presentation = size
  value.position = i + 1
  value.save!

  intl[size.to_sym] = value
end

## European Standard

type = Nelou::SizeOptionType.find_or_create_by(name: 'Size - Hats, Europe') do |type|
  type.name = 'Size - Hats, Europe'
  type.presentation = 'Size'
end

type.attributes = { name: 'Size - Hats, Europe', presentation: 'Size', locale: 'en' }
type.attributes = { name: 'Größe - Hüte, Europa', presentation: 'Größe', locale: 'de' }
type.save!

%w(52 53 54 55 56 57 58 59 60 61).each_with_index do |size, i|
  value = type.size_option_values.find_or_create_by(name: size) do |value|
    value.name = size
  end

  value.left_conversions.clear
  s = size.to_i
  if s >= 52 && s <= 53
    value.left_conversions << intl[:XS]
  end
  if s >= 54 && s <= 55
    value.left_conversions << intl[:S]
  end
  if s >= 56 && s <= 57
    value.left_conversions << intl[:M]
  end
  if s >= 58 && s <= 59
    value.left_conversions << intl[:L]
  end
  if s >= 60 && s <= 61
    value.left_conversions << intl[:XL]
  end

  value.presentation = size
  value.position = i + 1
  value.save!
end
