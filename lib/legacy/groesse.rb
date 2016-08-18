module Legacy
  class Groesse

    def self.size_option_types_for_kind(kind_id)
      case kind_id.to_i
      when 1 then [Nelou::SizeOptionType.find_by(name: 'Size - Women, Germany'), Nelou::SizeOptionType.find_by(name: 'Size - Women, International')]
      when 2 then [Nelou::SizeOptionType.find_by(name: 'Size - Men, Germany'), Nelou::SizeOptionType.find_by(name: 'Size - Men, International')]
      when 9 then [mens_trousers]
      when 10 then [womens_trousers]
      when 11 then [Nelou::SizeOptionType.find_by(name: 'Size - Women, Germany'), Nelou::SizeOptionType.find_by(name: 'Size - Women, International')]
      when 12 then [ring_sizes]
      else []
      end
    end

    def self.find_option_value_for_size(option_type, size)
      option_type.size_option_values.find_or_create_by(name: size) do |o|
        o.name = size
        o.presentation = size
        o.option_type = option_type
      end
    end

    private

    def self.ring_sizes
      Nelou::SizeOptionType.find_or_create_by(name: 'Ringsizes') do |o|
        o.name = 'Ringsizes'
        o.presentation = 'Ring size'

        o.attributes = { name: 'Ringsizes', presentation: 'Ring size', locale: :en }
        o.attributes = { name: 'Ringgrößen', presentation: 'Ringgröße', locale: :de }
      end
    end

    def self.mens_trousers
      Nelou::SizeOptionType.find_or_create_by(name: "Size - Men's Trousers, Germany") do |o|
        o.name = "Size - Men's Trousers, Germany"
        o.presentation = "Size"

        o.attributes = { name: "Size - Men's Trousers, Germany", presentation: 'Size', locale: :en }
        o.attributes = { name: 'Größe - Herrenhosen, Deutschland', presentation: 'Größe', locale: :de }
      end
    end

    def self.womens_trousers
      Nelou::SizeOptionType.find_or_create_by(name: "Size - Women's Trousers, Germany") do |o|
        o.name = "Size - Women's Trousers, Germany"
        o.presentation = "Size"

        o.attributes = { name: "Size - Women's Trousers, Germany", presentation: 'Size', locale: :en }
        o.attributes = { name: 'Größe - Damenhosen, Deutschland', presentation: 'Größe', locale: :de }
      end
    end
  end
end
