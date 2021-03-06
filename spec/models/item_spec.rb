require 'rails_helper'

RSpec.describe Item, :type => :model do
  it "performs its own calculations properly" do
    item = FactoryGirl.create(:item)

    expect(item.taxes.length).to eq(0)

    expect(item.base_amount).to eq(16.65)
    expect(item.discount_amount).to eq(0)
    expect(item.net_amount).to eq(16.65)
    expect(item.effective_tax_rate).to eq(0)
    expect(item.tax_amount).to eq(0)

    item = FactoryGirl.create(:item_complete, discount: 10)

    expect(item.taxes.length).to eq(1)

    expect(item.base_amount).to eq(16.65)
    expect(item.discount_amount).to eq(1.665)
    expect(item.net_amount).to eq(14.985)
    expect(item.effective_tax_rate).to eq(21)
    expect(item.tax_amount).to eq(3.14685)

    item = FactoryGirl.create(:item_complete, with_retention: true)

    expect(item.taxes.length).to eq(2)

    expect(item.base_amount).to eq(16.65)
    expect(item.discount_amount).to eq(0)
    expect(item.net_amount).to eq(16.65)
    expect(item.effective_tax_rate).to eq(2)
    expect(item.tax_amount).to eq(0.333)

    item = FactoryGirl.create(:item)
    item.taxes << FactoryGirl.create(:tax_retention)

    expect(item.base_amount).to eq(16.65)
    expect(item.discount_amount).to eq(0)
    expect(item.net_amount).to eq(16.65)
    expect(item.effective_tax_rate).to eq(-19)
    expect(item.tax_amount).to eq(-3.1635)
  end
end
