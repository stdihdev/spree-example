module Nelou::DesignerLabelsHelper
  def designer_country_name(designer_label)
    if designer_label.present? && designer_label.country.present?
      country = ISO3166::Country.find_country_by_alpha2 designer_label.country
      if country.present?
        country.translation(I18n.locale)
      end
    end
  end

  def get_country_name(code)
    if code == 'MK'
      Spree.t(:macedonia)
    elsif code.present?
      country = ISO3166::Country.find_country_by_alpha2 code
      if country.present?
        country.translation(I18n.locale)
      else
        nil
      end
    end
  end

  def partition_hash(hash, columns = 4, country_sort = false)
    all_pairs = []
    member_count = 0
    hash.each { |k,v| all_pairs << [k, v]; member_count += v.count }

    if country_sort
      all_pairs = all_pairs.sort_by { |p| get_country_name(p.first).parameterize rescue '' }
    else
      all_pairs = all_pairs.sort_by(&:first)
    end

    threshold = member_count / columns;

    columns = []
    i = 0

    all_pairs.each do |pair|
      if columns[i].present? && columns[i].map(&:second).map(&:count).sum + pair.second.count >= (threshold * 1.18)
        i = i + 1
      end

      if columns[i].nil?
        columns[i] = []
      end

      columns[i] << pair
    end

    columns
  end
end
