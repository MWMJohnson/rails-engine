require 'rails_helper'

describe "Merchants API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name:"Abe")
    @merchant2 = Merchant.create!(name:"Bob")
    @merchant3 = Merchant.create!(name:"Bill")
  end
  
  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)
  
    expect(merchants).to be_a(Hash)
    expect(merchants).to have_key(:data)
    
    data = merchants[:data]
    expect(data).to be_an(Array)
    expect(data.count).to eq(3)

    data.each do |merchant|
      expect(merchant).to be_a(Hash)

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to eq("merchant")
      
      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
    
    merchant_attributes_1 = data[0][:attributes]
    merchant_attributes_2 = data[1][:attributes]
    merchant_attributes_3 = data[2][:attributes]
    
    expect(merchant_attributes_1[:name]).to eq("#{@merchant1.name}")
    expect(merchant_attributes_2[:name]).to eq("#{@merchant2.name}")
    expect(merchant_attributes_3[:name]).to eq("#{@merchant3.name}")
  end
end