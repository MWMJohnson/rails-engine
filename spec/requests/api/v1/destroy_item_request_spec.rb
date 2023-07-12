require 'rails_helper'

describe "Items API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")
  end

  it "can destroy an exitsting item" do
    item = create(:item, merchant_id: @merchant1.id)

    expect{ delete api_v1_item_path(item) }.to change(Item, :count).by(-1)

    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  # Need Sad Path

  # Need Edge Case for invoice-items, cannot delete parents before killing the kid.
end