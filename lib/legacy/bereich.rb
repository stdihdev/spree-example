# Because the original nelou was broken in every regard, the super-categories of
# the shop were never defined in the database, but given an ID that was fixed in
# code. This should ease the conversion.

module Legacy
  class Bereich

    def self.get_taxon_for_original_id(id)
      Spree::Taxonomy.find_or_create_by(id: id) do |t|
        t.id = id
        t.name = english_name_for_id(id)

        t.attributes = { name: german_name_for_id(id), locale: :de }
        t.attributes = { name: english_name_for_id(id), locale: :en }
      end
    end

    private

    def self.german_name_for_id(id)
      case id
      when 1 then 'Damen'
      when 2 then 'Herren'
      when 3 then '???'
      when 4 then 'Accessoires'
      when 5 then 'Schmuck'
      when 6 then 'Taschen'
      when 7 then 'Kinder'
      else
        '???'
      end
    end

    def self.english_name_for_id(id)
      case id
      when 1 then 'Women'
      when 2 then 'Men'
      when 3 then '???'
      when 4 then 'Accessories'
      when 5 then 'Jewellery'
      when 6 then 'Bags'
      when 7 then 'Kids'
      else
        '???'
      end
    end

  end
end
