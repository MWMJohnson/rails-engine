require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Jewelry")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 300, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 4.99, merchant_id: @merchant1.id)

    @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
    @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 99.99, merchant_id: @merchant2.id)
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items}
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "class methods" do
    describe ".find_item_by_name" do
      it "returns all items with matching results" do
        expect(Item.find_item_by_name(name: "ru")).to eq(@item_3)
      end

      it "returns all items in case_insensitive alaphabetical order " do
        expect(Item.find_item_by_name(name: "br")).to eq(@item_5)
      end
    end

    describe ".find_item_by_price" do 
      it "returns items based on the minimum price" do
        expect(Item.find_item_by_price(min_price: 4.99)).to eq(@item_5)
      end

      it "returns items based on the max price" do
        expect(Item.find_item_by_price(max_price: 99.99)).to eq(@item_8)
      end

      it "returns items based on both the min and max price" do
        expect(Item.find_item_by_price(min_price: 4.99, max_price: 99.99)).to eq(@item_8)
      end
    end

    describe ".find_item" do 
      it "returns an item based on the name if no price params are given" do
        expect(Item.find_item(name: "ru")).to eq(@item_3)
      end

      it "returns an item based on the price if given no name" do
        expect(Item.find_item(min_price: 10)).to eq(@item_5)
      end

      it "returns false, if a name and a price search query are given" do
        expect(Item.find_item(name: "ru", min_price: 10)).to be(false)
      end
    end
  end
end