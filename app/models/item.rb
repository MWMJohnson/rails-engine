class Item < ApplicationRecord
  validates :name, :description, :unit_price, :merchant_id, presence: true
  validates :unit_price, numericality: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_item_by_name(params)
    return false if params[:name].blank?
  
    Item.where("name ILIKE ?", "%#{params[:name]}%").order(:name).take
  end
  

  def self.find_item_by_price(params)
    min_price = params[:min_price].presence || 0
    max_price = params[:max_price].presence || 999_999

    Item.where("unit_price >= ? AND unit_price <= ?", min_price, max_price).order(:name).take
  end

  def self.find_item(params)
    if params[:name].present?
      if params[:min_price].present? || params[:max_price].present?
        return false
      else
        find_item_by_name(params)
      end
    else
      find_item_by_price(params)
    end
  end
end

