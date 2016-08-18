require 'rails_helper'

RSpec.describe Nelou::Calculator::AmountSalePriceCalculator, type: :model do
  let!(:store) { create :store }
  let(:calculator) { Nelou::Calculator::AmountSalePriceCalculator.new }
  let(:sale_price) { create :sale_price, value: 20 }

  describe '#compute' do

    it 'returns the price set by the sale' do
      expect(calculator.compute(sale_price)).to eq 20
    end

  end
end
