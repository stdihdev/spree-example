module Nelou
  module ContainsDesigner
    extend ActiveSupport::Concern

    included do
      scope :containing_designer, -> (designer_label) { includes(:designer_labels).where("#{Nelou::DesignerLabel.quoted_table_name}.id": designer_label.id) }
    end

    def contains_products_from_designer(designer_label)
      designer_labels.map(&:id).include?(designer_label.id)
    end
  end
end
