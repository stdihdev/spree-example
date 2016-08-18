require 'rails_helper'

RSpec.describe Nelou::DesignerLabel, type: :model do
  let!(:store) { create :store }
  let(:designer_label) { create :designer_label }
  let(:not_accepted_designer_label) { create :not_accepted_designer_label }
  let(:disabled_designer_label) { create :disabled_designer_label }

  it 'has a valid factory' do
    expect(designer_label).to be_valid
  end

  it 'must have a name' do
    designer_label.name = nil

    expect(designer_label).not_to be_valid
  end

  it 'must have an user' do
    designer_label.user = nil

    expect(designer_label).not_to be_valid
  end

  describe '.active' do

    it 'returns only active users' do
        active_designer_label = create :designer_label, active: true, accepted: true
        inactive_designer_label = create :designer_label, active: false
        unacceptable_designer_label = create :designer_label, accepted: false

        result = Nelou::DesignerLabel.active

        expect(result).to include active_designer_label
        expect(result).not_to include inactive_designer_label, unacceptable_designer_label
      end

  end

  describe '.featured' do

    it 'returns only featured users' do
        active_designer_label = create :designer_label, active: true, accepted: true, featured: true
        inactive_designer_label = create :designer_label, active: false, featured: true
        unfeatured_designer_label = create :designer_label, active: true, accepted: true, featured: false

        result = Nelou::DesignerLabel.featured

        expect(result).to include active_designer_label, inactive_designer_label
        expect(result).not_to include  unfeatured_designer_label
      end

  end

end
