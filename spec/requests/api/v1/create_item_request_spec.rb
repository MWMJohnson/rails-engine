require 'rails_helper'

describe "Items API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")
  end

  it "can create a new item" do
  item_params = ({
                  name: 'Soul Glow!',
                  description: 'Great for people coming to America!',
                  unit_price: 1000,
                  merchant_id: @merchant1.id,
                })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(item_params[:name]).to eq(created_item.name)
    expect(item_params[:description]).to eq(created_item.description)
    expect(item_params[:unit_price]).to eq(created_item.unit_price)
    expect(item_params[:merchant_id]).to eq(created_item.merchant_id)
  end
end