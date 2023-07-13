class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find_all
    if params[:name].blank?
      render(status: 404, json: { error: 'Merchant not found' } )
    elsif Merchant.find_all_merchants(params[:name]).empty?
      render(status: 200, json: { data: [] })
    else 
      render json: MerchantSerializer.new(Merchant.find_all_merchants(params[:name]))
    end
  end

end
