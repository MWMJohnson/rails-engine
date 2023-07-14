require 'rails_helper'

describe "Merchants Endpoints" do
  before(:each) do 
    @merchant1 = Merchant.create!(name:"Abe")
    @merchant2 = Merchant.create!(name:"Bob")
    @merchant3 = Merchant.create!(name:"Bill")
    
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    
    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
  end

  describe " GET /api/v1/merchants" do 
    describe "happy path" do 
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
        
        merchant1_attributes = data[0][:attributes]
        merchant2_attributes = data[1][:attributes]
        merchant3_attributes = data[2][:attributes]
        
        expect(merchant1_attributes[:name]).to eq(@merchant1.name)
        expect(merchant2_attributes[:name]).to eq(@merchant2.name)
        expect(merchant3_attributes[:name]).to eq(@merchant3.name)
      end
    end

    # Q1
    # describe "sad path" do
    # Do we need a sad path in case the website is down? Otherwise I cannot think of another sad path to test for?
  end

  describe " GET /api/v1/merchant/:id" do 
    describe "happy path" do 
      it "shows one merchant" do 
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

    describe "sad path" do 
      it "rejects request if merchant does not exist" do 
        merchant_id = 1902933094309327094537
        get "/api/v1/merchants/#{merchant_id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Merchant.find(merchant_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'edge case' do 
      it "rejects request if user types in a String" do 
        merchant_id = "1902933094309327094537"
        get '/api/v1/merchants/Abe'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect{Merchant.find(merchant_id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe " GET /api/v1/merchants/find_all" do
    before(:each) do 
      @merchant5 = Merchant.create!(name: "Sea World Store")
      @merchant6 = Merchant.create!(name: "Fury Seals")
      @merchant7 = Merchant.create!(name: "Fun by the SEA!")
      @merchant8 = Merchant.create!(name: "Sesame seasticks l.l.p.")
      @merchant9 = Merchant.create!(name: "Samsean Seasoning Inc.")
    end

    describe "happy path" do 
      it "returns merchant search results with a fragmented name search" do 
        search_params = {
          name: "sea"
                      }
        
        get "/api/v1/merchants/find_all", params: search_params

        expect(response).to be_successful
        expect(response.status).to eq(200)

        resp = JSON.parse(response.body, symbolize_names: true)

        data = resp[:data]

        expect(data).to be_an(Array)
        expect(data.count).to eq(5)

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

        search_result1 = data[0][:attributes]
        search_result3 = data[2][:attributes]
        search_result5 = data[4][:attributes]

        expect(search_result1[:name]).to eq(@merchant5.name)
        expect(search_result3[:name]).to eq(@merchant7.name)
        expect(search_result5[:name]).to eq(@merchant9.name)
      end
    end

    describe "sad path" do 
      it "accounts for no matching search results" do
        search_params = {
          name: "thisshouldwork"
                      }
        
        get "/api/v1/merchants/find_all", params: search_params

        expect(response).to be_successful
        expect(response.status).to eq(200)

        resp = JSON.parse(response.body, symbolize_names: true)
    
        expect(resp).to have_key(:data)
  
        expect(resp[:data]).to eq([])
      end
    end
  end

end
