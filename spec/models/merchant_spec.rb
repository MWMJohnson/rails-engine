require 'rails_helper'

describe Merchant do
  before(:each) do 
    @merchant1 = Merchant.create!(name: "Sea World Store")
    @merchant2 = Merchant.create!(name: "The Sea Store")
    @merchant3 = Merchant.create!(name: "The Store for seaLs")
    @merchant4 = Merchant.create!(name: "Jakeworlt")
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "class methods" do 
    describe ".find_all_merchants(name_param)" do 
      it "finds merchants results that match the query param" do 
        expect(Merchant.find_all_merchants("Jake")).to eq([@merchant4])
      end

      it "finds multiple merchants results that match the query param" do 
        expect(Merchant.find_all_merchants("Sea")).to eq([@merchant1, @merchant2, @merchant3])
      end

      it "returns an empty array if no matching results" do 
        expect(Merchant.find_all_merchants("Ari")).to eq([])
      end

      it "returns insensitive-case matching results " do 
        expect(Merchant.find_all_merchants("worl")).to eq([@merchant1, @merchant4])
      end
    end
  end
end