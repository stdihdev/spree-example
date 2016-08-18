module Nelou
  class SizeOptionValue < Spree::OptionValue
    has_and_belongs_to_many :left_conversions,
                            class_name: 'Nelou::SizeOptionValue',
                            join_table: :nelou_size_option_value_conversions,
                            foreign_key: :size_option_value_id,
                            association_foreign_key: :alias_id
    has_and_belongs_to_many :right_conversions,
                            class_name: 'Nelou::SizeOptionValue',
                            join_table: :nelou_size_option_value_conversions,
                            association_foreign_key: :size_option_value_id,
                            foreign_key: :alias_id

    scope :except_from, -> (option_type) { where.not(option_type_id: option_type.id) }

    def name_for_select
      "#{name} (#{option_type.name})"
    end

    def conversions
      (left_conversions + right_conversions).flatten.uniq
    end

  end
end
