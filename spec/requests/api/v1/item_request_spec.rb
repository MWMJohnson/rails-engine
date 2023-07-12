require 'rails_helper'

describe "Merchants API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
  end
  
  it "shows one item" do
    get api_v1_item_path(@item_1.id)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
  
    expect(items).to be_a(Hash)
    expect(items).to have_key(:data)
    
    data = items[:data]
    expect(data).to be_a(Hash)
  
    expect(data).to have_key(:id)
    expect(data[:id]).to be_an(String)
    expect(data[:id]).to eq(@item_1.id.to_s)
    
    expect(data).to have_key(:type)
    expect(data[:type]).to be_a(String)
    expect(data[:type]).to eq("item")
    
    expect(data).to have_key(:attributes)
    attributes = data[:attributes]
    expect(attributes).to be_a(Hash)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
    expect(attributes[:name]).to eq(@item_1.name)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)
    expect(attributes[:description]).to eq(@item_1.description)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(Float)
    expect(attributes[:unit_price]).to eq(@item_1.unit_price)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_an(Integer)
    expect(attributes[:merchant_id]).to eq(@item_1.merchant_id)
  end
end