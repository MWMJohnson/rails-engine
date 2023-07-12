require 'rails_helper'

describe "Merchants API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
  end
  
  it "sends a list of all items" do
    get api_v1_items_path

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
  
    expect(items).to be_a(Hash)
    expect(items).to have_key(:data)
    
    data = items[:data]
    expect(data).to be_an(Array)
    expect(data.count).to eq(8)

    data.each do |item|
      expect(item).to be_a(Hash)

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      
      expect(item).to have_key(:attributes)
      attributes = item[:attributes]
      expect(attributes).to be_a(Hash)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_an(Integer)
    end

    item1_attributes = data[0][:attributes]
  
    expect(item1_attributes[:name]).to eq(@item_1.name)
    expect(item1_attributes[:description]).to eq(@item_1.description)
    expect(item1_attributes[:unit_price]).to eq(@item_1.unit_price)
    expect(item1_attributes[:merchant_id]).to eq(@item_1.merchant_id)
    
    item4_attributes = data[3][:attributes]
  
    expect(item4_attributes[:name]).to eq(@item_4.name)
    expect(item4_attributes[:description]).to eq(@item_4.description)
    expect(item4_attributes[:unit_price]).to eq(@item_4.unit_price)
    expect(item4_attributes[:merchant_id]).to eq(@item_4.merchant_id)
  end
end