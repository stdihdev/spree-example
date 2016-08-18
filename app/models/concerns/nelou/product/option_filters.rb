module Nelou
  module Product
    module OptionFilters
      extend ActiveSupport::Concern

      included do
        scope :option_any, -> (opts) { joins(:variants_including_master => :option_values).where("#{Spree::OptionValue.quoted_table_name}.id": opts) }
        scope :option_all, -> (opts) { option_any(opts).group("#{Spree::Product.quoted_table_name}.id").having("COUNT(DISTINCT #{Spree::OptionValue.quoted_table_name}.id) = ?", opts.length) }
      end
    end
  end
end
