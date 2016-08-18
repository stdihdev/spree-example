require File.join(__dir__, 'concerns', 'legacy', 'fix_broken_letters.rb')

module Legacy
  class Produkt < ActiveRecord::Base
    include Legacy::FixBrokenLetters

    establish_connection :legacy_nelou
    self.primary_key = 'id'
    self.table_name = 'bs_shop_produkte'

    def migrate!
      return if Spree::Product.exists?(id: id)

      product = Spree::Product.find_or_initialize_by(id: id) do |p|
        p.id = id
      end

      product.designer_label = designer_label
      product.available_on = nil
      product.available_on = created_at if online > 0
      product.created_at = created_at
      product.production_type = production_type
      product.shipping_category = Spree::ShippingCategory.paket
      product.eco = green
      product.price = sale ? preis_presale : preis_brutto
      product.photo_credits = fotocredits
      product.name = headline_en
      product.description = text_en
      product.meta_description = kurztext_en
      product.sku = [designer_label.name, artikelcode, id.to_s].reject(&:nil?).reject(&:blank?).join(' ')

      product.attributes = {
        locale: :de,
        name: headline,
        description: text,
        meta_title: headline,
        meta_description: kurztext
      }

      product.attributes = {
        locale: :en,
        name: headline_en,
        description: text_en,
        meta_title: headline_en,
        meta_description: kurztext_en
      }

      product.master.track_inventory = false

      if attributes_before_type_cast['stueck_limitiert'] > 0
        product.master.limited = true
        product.master.limited_items = stueck_total
        product.master.limited_items_sold = stueck_total - stueck_counter
      end

      product.variants.destroy_all
      colours.each do |colour|
        if sizes.any?
          sizes.each do |size|
            product.variants.build do |v|
              v.track_inventory = false
              v.option_values << colour
              v.option_values << size

              if attributes_before_type_cast['stueck_limitiert'] > 0
                v.limited = true
                v.limited_items = items_per_size(size.name)
                v.limited_items_sold = 0
              end
            end
          end
        else
          product.variants.build do |v|
            v.track_inventory = false
            v.limited = product.master.limited
            v.limited_items = product.master.limited_items
            v.limited_items_sold = product.master.limited_items_sold
            v.option_values << colour
          end
        end
      end

      product.taxons.clear

      product.transaction do
        product.taxons << Legacy::Bereich.get_taxon_for_original_id(bereich).root
        product.taxons << Legacy::Kategorie.find(kategorie).get_spree_taxonomy

        product.option_types.clear
        if colours.any?
          product.option_types << Spree::OptionType.colour
        end

        unless has_size?
          add_special_size(product)
        else
          size_option_types.each do |option_type|
            product.option_types << option_type
          end
        end

        product.save!

        if sale
          product.put_on_sale(preis_presale - preis_brutto)
        end

        product.master.images.destroy_all
        1.upto(5).each do |i|
          name = self.send("bild#{i}".to_sym)
          next unless is_image_acceptable?(name)

          url = image_url(name)

          Spree::Image.create!(attachment: URI.parse(url), viewable: product.master) if check_url(url)
        end
      end

      puts "Done with product #{id}: #{product.name}"

      product
    rescue => e
      puts "Problem with product #{id}: #{e}"
      puts e.backtrace
    end

    def self.migrate_all!
      Legacy::Produkt.order(id: :desc).each(&:migrate!)
    end

    def created_at
      if datum.nil?
        Date.parse('2009-03-09')
      else
        datum
      end
    end

    def designer_label
      Nelou::DesignerLabel.find(designer)
    end

    def colour_list
      farbcode.gsub('**', '&&').split('|').map { |c| c.split('*').second }.reject(&:nil?).map { |c| c.split('&&') }.flatten.reject(&:blank?).uniq
    end

    def colours
      colour_list.map do |c|
        Legacy::Farbe.find(c).get_spree_option_value
      end
    end

    def size_kind
      groessencode.split('*', 2).first
    end

    def size_option_types
      Legacy::Groesse.size_option_types_for_kind(size_kind)
    end

    def size_values
      v = groessencode.split('*', 2).second
      if v.present?
        v.split('**').reject(&:nil?).map { |t| t.gsub('*', '') }.reject(&:blank?)
      else
        []
      end
    end

    def has_size?
      not [3, 4, 5, 6, 7, 8, 13, 14, 15].include?(size_kind)
    end

    def add_special_size(p)
      prop = Spree::Property.find_or_create_by(name: 'Size') do |prop|
        prop.name = 'Size'
        prop.presentation 'Size'

        prop.attributes = { name: 'Size', presentation: 'Size', locale: :en }
        prop.attributes = { name: 'Größe', presentation: 'Größe', locale: :de }
      end

      p.product_properties.clear
      p.product_properties.build do |pp|
        pp.value = groessen_en
        pp.property = prop
      end
    end

    def sizes
      size_values.map do |sv|
        if /[0-9]+/.match(sv)
          Legacy::Groesse.find_option_value_for_size(size_option_types.first, sv) if size_option_types.first.present?
        else
          Legacy::Groesse.find_option_value_for_size(size_option_types.second, sv) if size_option_types.second.present?
        end
      end
    end

    def production_type
      case lieferung
      when 1
        :on_demand
      when 3
        :ready_to_wear
      when 4
        :custom_made
      else
        :ready_to_wear
      end
    end

    def items_per_size(sv)
      groessen_stueckzahlen.split('*').each do |t|
        v = t.split(':', 2)
        if v.first == sv
          return v.second.to_i
        end
      end

      return 0
    end

    private

    def is_image_acceptable?(name)
      accepted_formats = ['.png', '.jpg', '.jpeg', '.gif']

      name.present? && accepted_formats.include?(File.extname(name).downcase)
    end

    def get_spree_country
      Land.find(land).get_spree_country
    end

    def image_url(name)
      "http://s3-eu-west-1.amazonaws.com/nelou/images/xl_#{name}"
    end

    def check_url(url)
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response = request.request_head uri.path
      response.code.to_i == 200
    end
  end
end
