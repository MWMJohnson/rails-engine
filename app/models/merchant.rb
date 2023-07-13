class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_all_merchants(name_param)
    merchants = Merchant.where("name ILIKE ?", "%#{name_param}%")
  end
end