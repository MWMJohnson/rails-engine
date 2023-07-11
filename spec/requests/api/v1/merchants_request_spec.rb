require 'rails_helper'

describe "Merchants API" do
  
  # let!(:merchant1) { Merchant.create(name: "Abe") }
  # let!(:merchant2) { Merchant.create(name: "Bob") }
  # let!(:merchant3) { Merchant.create(name: "Bill") }

  before(:each) do 
    @merchant1 = Merchant.create!(name:"Abe")
    @merchant2 = Merchant.create!(name:"Bob")
    @merchant3 = Merchant.create!(name:"Bill")
  end
  
  it "sends a list of merchants" do
    # merchant1.reload
    # merchant2.reload
    # merchant3.reload
    # create_list(:merchant, 3)
    # require 'pry'; binding.pry
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants.count).to eq(3)
    # require 'pry'; binding.pry
    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
    # require 'pry'; binding.pry
    merchant1 = merchants[0]
    merchant2 = merchants[1]
    merchant3 = merchants[2]

    expect(merchant1[:name]).to eq("#{@merchant1.name}")
    expect(merchant2[:name]).to eq("#{@merchant2.name}")
    expect(merchant3[:name]).to eq("#{@merchant3.name}")
  end
end