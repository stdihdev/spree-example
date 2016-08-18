FactoryGirl.define do
  factory :sale_price, :class => 'Nelou::SalePrice' do
    value 20
    start_at { Date.today }
    end_at { Date.today + 1.month }
    enabled true
    calculator_type Nelou::Calculator::AmountSalePriceCalculator.name
    association :variant, factory: :variant

    factory :gone_by_sale_price do
      start_at { Date.today - 1.month }
      end_at { Date.yesterday }
    end

    factory :future_sale_price do
      start_at { Date.tomorrow }
      end_at { Date.tomorrow + 1.month }
    end
  end

end
