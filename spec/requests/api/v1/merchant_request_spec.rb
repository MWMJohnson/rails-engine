require 'rails_helper'

describe "Merchants API" do
  before(:each) do 
    @merchant1 = Merchant.create!(name:"Abe")
    @merchant2 = Merchant.create!(name:"Bob")
  end
  
  it "sends one merchant in a JSON API format" do 
    get api_v1_merchant_path(@merchant1.id)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to be_a(Hash)
    expect(merchant).to have_key(:data)

    data = merchant[:data]
    expect(data).to be_a(Hash)

    expect(data).to have_key(:id)
    expect(data[:id]).to be_a(String)
    expect(data[:id]).to eq(@merchant1.id.to_s)

    expect(data).to have_key(:type)
    expect(data[:type]).to eq("merchant")

    expect(data).to have_key(:attributes)
    attributes = data[:attributes]
    expect(attributes).to be_a(Hash)

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
    expect(attributes[:name]).to eq(@merchant1.name)

    #not sure if needed ...
    # expect(attributes.values.include?(@merchant2.name)).to be(false)
  end
end