require 'rails_helper'

RSpec.describe Nelou::SalePrice, type: :model do
  let!(:store) { create :store }
  let(:sale_price) { create :sale_price }

  it 'has a valid factory' do
    expect(sale_price).to be_valid
  end

end
