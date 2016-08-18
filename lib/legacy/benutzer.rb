require File.join(__dir__, 'concerns', 'legacy', 'fix_broken_letters.rb')

module Legacy
  class Benutzer < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_styleaut
    self.table_name = 'bs_benutzer'

    def migrate!
      if id < 50_000
        raise 'ignored'
      end

      # return if Spree::User.exists?(id: id)

      user = Spree::User.find_or_initialize_by(id: id) do |user|
        user.id = id
      end

      user.email = email
      user.legacy_username = username
      user.legacy_password = passwort
      user.created_at = datum_anmeldung
      user.locale = sprache

      user.subscribed = false # newsletter

      user.addresses.clear.build do |a|
        a.gender = gender
        a.firstname = vorname
        a.lastname = nachname
        a.company = firma
        a.address1 = strasse
        a.zipcode = plz.slice(0, 10)
        a.city = ort
        a.country = get_spree_country
        a.phone = telefon
      end

      user.bill_address = user.addresses.first
      user.ship_address = user.addresses.first

      user.transaction do
        user.skip_confirmation!
        user.save!(validate: false)
        user.addresses.each(&:save!)
      end

      puts "Imported user #{id} (#{name}, #{email})"

      user
    rescue => e
      puts "Problems with user #{id} (#{name}, #{email}): #{e}"
    end

    def gender
      if %w(m f).include?(anrede)
        anrede
      else
        'm'
      end
    end

    def get_spree_country
      Land.find(land).get_spree_country
    end

    def name
      vorname.strip + ' ' + nachname.strip
    end

    def self.migrate_all!
      Legacy::Benutzer.all.find_each(&:migrate!)
    end
  end
end
