module Legacy
  class Farbe < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_nelou
    self.primary_key = 'id'
    self.table_name = 'bs_shop_farben'

    def get_spree_option_value
      Spree::OptionValue.find_or_create_by(name: name_en) do |v|
        v.name = name_en
        v.presentation = name_en
        v.position = id
        v.option_type = Spree::OptionType.colour

        v.attributes = { name: name_de, presentation: name_de, locale: :de }
        v.attributes = { name: name_en, presentation: name_en, locale: :en }
      end
    end
  end
end
