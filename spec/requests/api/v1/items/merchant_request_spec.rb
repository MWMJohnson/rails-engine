require 'rails_helper'

describe "Items::Merchant Endpoints" do
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

  describe 'GET /api/v1/items/:id/merchant' do 
    describe 'happy path' do 
      it "sends info about the merchant the item belongs to" do 
        get "/api/v1/items/#{@item_1.id}/merchant"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        merchant = JSON.parse(response.body, symbolize_names: true)
        
        expect(merchant).to be_a(Hash)
        expect(merchant).to have_key(:data)
        expect(merchant[:data]).to be_a(Hash)

        data = merchant[:data]

        expect(data).to have_key(:id)
        expect(data[:id]).to be_a(String)
        expect(data[:id]).to eq(@item_1.merchant.id.to_s)

        expect(data).to have_key(:type)
        expect(data[:type]).to be_a(String)
        expect(data[:type]).to eq("merchant")

        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
        expect(attributes[:name]).to eq(@item_1.merchant.name)
      end
    end

    describe 'sad path' do 
      it "rejects request if item does not exist" do 
        item_id = 10898989898983

        get "/api/v1/items/#{item_id}/merchant"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'edge case' do 
      it "rejects request if user inputs a String" do 
        item_id = "10898989898983"

        get "/api/v1/items/#{item_id}/merchant"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end