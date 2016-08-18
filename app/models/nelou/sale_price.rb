module Nelou
  class SalePrice < Nelou::BaseModel
    belongs_to :price, class_name: 'Spree::Price'
    has_one :variant, through: :price
    has_one :product, through: :variant

    has_one :calculator, class_name: 'Spree::Calculator', as: :calculable, dependent: :destroy
    accepts_nested_attributes_for :calculator
    validates :calculator, presence: true

    scope :active, -> { where('enabled = ? AND (start_at <= ? OR start_at IS NULL) AND (end_at >= ? OR end_at IS NULL)', true, Time.now, Time.now) }

    def calculator_type
      calculator.class.to_s if calculator
    end

    def calculator_type=(calculator_type)
      clazz = calculator_type.constantize if calculator_type
      self.calculator = clazz.new if clazz && (!calculator.is_a? clazz)
    end

    def price
      calculator.compute self
    end

    def enable
      update_attribute(:enabled, true)
    end

    def disable
      update_attribute(:enabled, false)
    end

    def start(end_time = nil)
      end_time = nil if end_time.present? && end_time <= Time.now # if end_time is not in the future then make it nil (no end)
      attr = { end_at: end_time, enabled: true }
      attr[:start_at] = Time.now if start_at.present? && start_at > Time.now # only set start_at if it's not set in the past
      update_attributes(attr)
    end

    def stop
      update_attributes(end_at: Time.now, enabled: false)
    end
  end
end
