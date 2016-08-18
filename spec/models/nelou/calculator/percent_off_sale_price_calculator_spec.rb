require 'rails_helper'

RSpec.describe Nelou::Calculator::PercentOffSalePriceCalculator, type: :model do
  let!(:store) { create :store }
  let(:calculator) { Nelou::Calculator::PercentOffSalePriceCalculator.new }
  let(:sale_price) { create :sale_price, value: 0.2 }

  describe '#compute' do

    it 'returns the price set by the sale' do
      sale_price.variant.price = 50 # TODO: Figure out where to put it so it isn't constantly ignored

      expect(calculator.compute(sale_price)).to eq 40
    end

  end
end
