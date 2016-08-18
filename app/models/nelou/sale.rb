module Nelou
  class Sale
    include ActiveModel::Model

    attr_accessor :start_at, :end_at, :calculator_type, :amount

    # before_validation :correct_amount_for_percentage

    validates :start_at,
              date: { after_or_equal_to: proc { Date.today } },
              presence: true
    validates :end_at,
              date: { after: :start_at },
              allow_nil: true
    validates :calculator_type,
              presence: true,
              inclusion: {
                in: %w(Nelou::Calculator::AmountSalePriceCalculator Nelou::Calculator::PercentOffSalePriceCalculator)
              }
    validates :amount,
              presence: true,
              numericality: { greater_than: 0 }

    def start_at=(start_at)
      if start_at.kind_of? String
        @start_at = Date.parse start_at
      else
        @start_at = start_at
      end
    end

    def end_at=(end_at)
      if end_at.kind_of? String
        @end_at = Date.parse end_at
      else
        @end_at = end_at
      end
    end

    def amount
      if calculator_type == 'Nelou::Calculator::PercentOffSalePriceCalculator'
        @amount.to_f / 100
      else
        @amount.to_f
      end
    end
  end
end
