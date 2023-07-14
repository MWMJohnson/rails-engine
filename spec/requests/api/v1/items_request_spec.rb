require 'rails_helper'

describe "Items API" do
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
  
  describe "GET /api/v1/items" do 
    describe "happy path" do 
      it "returns a list of all items" do
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

    describe 'sad path' do 
      #Not sure if needed, unless API website is down??
    end
  end

  describe "GET /api/v1/items/:id" do 
    describe "happy path" do
      it "returns one item" do
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

    describe 'sad path' do
      it "rejects request if item does not exist" do 
        item_id = 10898989898983

        get "/api/v1/items/#{item_id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'edge case' do
      it "rejects request if user inputs a String" do 
        item_id = "10898989898983"

        get "/api/v1/items/#{item_id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Item.find(item_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe 'POST /api/v1/items' do 
    describe 'happy path' do 
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

    describe 'sad path' do 
      # Need Sad Path
    end

    describe 'edge case' do 
      # Need Edge Case
    end
  end

  describe 'DELETE /api/v1/items' do
    describe 'happy path' do 
      it 'can delete an item' do 
        item = create(:item, merchant_id: @merchant1.id)
    
        expect{ delete api_v1_item_path(item) }.to change(Item, :count).by(-1)
    
        expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'sad path' do 
      # Need Sad Path
    end

    describe 'edge case' do 
      # Need Edge Case for invoice-items, cannot delete parents before killing the kid.
    end
  end

  describe 'PUT /api/v1/items' do
    describe 'happy path' do 
      it "can update an existing item" do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = { name: "Sweet Sweet Toothpaste" }
        headers = {"CONTENT_TYPE" => "application/json"}

        put api_v1_item_path(id), headers: headers, params: JSON.generate({item: item_params})
        item = Item.find_by(id: id)
    
        expect(response).to be_successful
        expect(item.name).to_not eq(previous_name)
        expect(item.name).to eq("Sweet Sweet Toothpaste")
      end
    end

    describe 'sad path' do 
      # Need Sad Path
    end

    describe 'edge case' do 
      # Need Edge Case
    end
  end

  describe 'GET /api/v1/items/:id/merchant' do 
    describe 'happy path' do 
      it "sends the merchant the item belongs to" do 
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