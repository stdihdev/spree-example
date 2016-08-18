require File.join(__dir__, 'concerns', 'legacy', 'fix_broken_letters.rb')

module Legacy
  class Land < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_nelou
    self.primary_key = 'id'
    self.table_name = 'bs_laender'

    def get_spree_country
      Spree::Country.where(iso: iso_code).first
    end

    private

    def iso_code
      if name_en.eql? 'USA'
        self.name_en = 'United States of America'
      elsif name_en.eql? 'Mexiko'
        self.name_en = 'Mexico'
      elsif name_en.eql? 'Brasil'
        self.name_en = 'Brazil'
      elsif name_en.eql? 'Dubai'
        self.name_en = 'United Arab Emirates'
      elsif name_en.eql? 'South Korea'
        self.name_en = 'Korea (Republic of)'
      end

      iso = IsoCountryCodes.search_by_name(name_en.strip).first
      iso.alpha2
    end
  end
end
