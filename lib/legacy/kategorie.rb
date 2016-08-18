module Legacy
  class Kategorie < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_nelou
    self.primary_key = 'id'
    self.table_name = 'bs_shop_kategorien'

    def get_spree_taxonomy
      Spree::Taxon.find_or_create_by(name: headline_en) do |t|
        t.name = headline_en
        t.position = pos
        t.parent = Legacy::Bereich.get_taxon_for_original_id(bereich).root

        t.attributes = { name: headline, locale: :de }
        t.attributes = { name: headline_en, locale: :en }
      end
    end
  end
end
