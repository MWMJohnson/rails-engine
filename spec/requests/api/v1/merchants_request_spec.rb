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

    merchants = JSON.parse(response.body, symbolize_names: true)
  
    expect(merchants).to be_a(Hash)
    expect(merchants).to have_key(:data)
    
    data = merchants[:data]
    expect(data).to be_an(Array)

    data.each do |merchant|
      expect(merchant).to be_a(Hash)
      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      expect(attributes).to be_a(Hash)
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
    
    merchant1 = data[0][:attributes]
    merchant2 = data[1][:attributes]
    merchant3 = data[2][:attributes]
    
    expect(merchant1[:name]).to eq("#{@merchant1.name}")
    expect(merchant2[:name]).to eq("#{@merchant2.name}")
    expect(merchant3[:name]).to eq("#{@merchant3.name}")
  end
end