require File.join(__dir__, 'concerns', 'legacy', 'fix_broken_letters.rb')

module Legacy
  class Designer < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_nelou
    self.table_name = 'bs_designer'
    self.primary_key = :id

    def migrate!
      designer_label = Nelou::DesignerLabel.find_or_initialize_by(id: id) do |d|
        d.id = id
      end

      designer_label.build_user unless designer_label.user.present?
      user = designer_label.user

      raise 'Blank email' unless the_email.present?

      user.email = the_email
      user.legacy_password_hash = passwort
      user.legacy_username = username
      user.subscribed = false # newsletter
      user.locale = sprache
      user.spree_roles << Spree::Role.designer_role

      designer_label.slug = url_id
      designer_label.name = name
      designer_label.green = green
      designer_label.selection = selection
      designer_label.active = aktiv
      designer_label.accepted = online > 0
      designer_label.vat = uid unless uid.blank? || uid.length >= 50
      designer_label.paypal = paypal
      designer_label.website = website
      designer_label.photo_credits = kst_fotocredits if kst_fotocredits.present?
      designer_label.photo_credits = nil if kst_fotocredits.nil? || kst_fotocredits.blank?
      designer_label.background_colour = kst_hg
      designer_label.iban = iban
      designer_label.bic = bic
      designer_label.city = ort if ort.present?
      designer_label.country = get_spree_country.iso rescue nil
      # designer_label.facebook_id = facebook_id

      designer_label.attributes = {
        locale: :de,
        name: headline,
        profile: profiltext,
        short_description: kst_text,
        slug: url_id
      }

      designer_label.attributes = {
        locale: :en,
        name: headline_en,
        profile: profiltext_en,
        short_description: kst_text_en,
        slug: url_id_en.present? ? url_id_en : url_id
      }

      migrate_bill_address(user)
      migrate_ship_address(user)

      designer_label.logo_from_url image_url(bild1) if is_image_acceptable?(:bild1)
      designer_label.profile_image_from_url image_url(bild3) if is_image_acceptable?(:bild3)

      designer_label.transaction do
        user.skip_confirmation!
        user.save!(validate: false)
        designer_label.user = user
        designer_label.save!(validate: false)
        # user.addresses.each(&:save!)
      end

      #puts "Imported designer #{id} (#{name}, #{email})"
      print '.'
      STDOUT.flush

      designer_label
    rescue => e
      puts "Problems with designer #{id} (#{name}, #{the_email}): #{e}"
    end

    def the_email
      email || email2
    end

    def name
      headline
    end

    def gender
      if %w(m f).include?(anrede)
        anrede
      else
        'f'
      end
    end

    def self.migrate_all!
      all.find_each(&:migrate!)
    end

    private

    def migrate_bill_address(user)
      user.bill_address = user.addresses.clear.build do |a|
        a.gender = gender
        a.firstname = vorname.present? ? vorname : '-'
        a.lastname = nachname.present? ? nachname : '-'
        a.company = firmenname
        a.address1 = strasse.present? ? strasse : '-'
        a.zipcode = plz.present? ? plz.slice(0, 10) : '00000'
        a.city = ort.present? ? ort : '-'
        a.country = get_spree_country
        a.phone = telefon
      end
    end

    def migrate_ship_address(user)
      if gls_adresse.present?
        user.ship_address = user.addresses.build do |a|
          name = if gls_name3.blank?
                   ['-', '-']
                 else
                   gls_name3.split(' ', 2)
                 end

          a.gender = gender
          a.firstname = name.length > 1 ? name[0] : '-'
          a.lastname = name.length > 1 ? name[1] : name[0]
          a.company = gls_name2
          a.address1 = gls_adresse
          a.zipcode = gls_plz
          a.city = gls_ort
          a.country = get_spree_country
        end
      end
    end

    def is_image_acceptable?(attrname)
      accepted_formats = ['.png', '.jpg', '.jpeg', '.gif']

      str = read_attribute(attrname)

      str.present? && accepted_formats.include?(File.extname(str).downcase)
    end

    def get_spree_country
      Land.find(land).get_spree_country
    end

    def image_url(name)
      "http://www.nelou.com/images/database/#{name}"
    end
  end
end
