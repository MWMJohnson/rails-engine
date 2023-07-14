require 'rails_helper'

describe "Items::Search Endpoints" do
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

  describe "GET /api/v1/items/find" do
    describe "happy path" do
      it "finds one item based on a name search result" do
        search_params = {
          name: "br"
      }

      get "/api/v1/items/find", params: search_params

      expect(response).to be_successful
      expect(response.status).to eq(200)

      resp = JSON.parse(response.body, symbolize_names: true)

      expect(resp.count).to eq(1)
      expect(resp).to have_key(:data)
      data = resp[:data]
      expect(data).to be_a(Hash)
      
      expect(data).to have_key(:id)
      expect(data[:id]).to be_a(String)
      expect(data[:id]).to eq(@item_5.id.to_s)

      expect(data).to have_key(:type)
      expect(data[:type]).to be_a(String)
      expect(data[:type]).to eq("item")

      expect(data).to have_key(:attributes)
      attributes = data[:attributes]
      expect(attributes).to be_a(Hash)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
      expect(attributes[:name]).to eq(@item_5.name)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)
      expect(attributes[:description]).to eq(@item_5.description)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
      expect(attributes[:unit_price]).to eq(@item_5.unit_price)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_an(Integer)
      expect(attributes[:merchant_id]).to eq(@item_5.merchant_id)
      end
    end

    describe "sad path" do 
      it "returns a null item if no match" do 
        search_params = {
          name: "thisshouldwork"
        }
  
        get "/api/v1/items/find", params: search_params
  
        expect(response).to be_successful
        expect(response.status).to eq(200)
  
        resp = JSON.parse(response.body, symbolize_names: true)
  
        expect(resp).to have_key(:data)
        data = resp[:data]

        expect(data).to be_a(Hash)
        expect(data)
  
        expect(data).to have_key(:id)
        expect(data[:id]).to eq(nil)

        expect(data).to have_key(:type)
        expect(data[:type]).to be_a(String)
        expect(data[:type]).to eq("item")

        expect(data).to have_key(:attributes)
        attributes = data[:attributes]
        expect(attributes).to be_a(Hash)

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to eq(nil)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to eq(nil)

        expect(attributes).to have_key(:unit_price)
        expect(attributes[:unit_price]).to eq(nil)

        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to eq(nil)
      end
    end
  end
end