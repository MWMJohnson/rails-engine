class Api::V1::Merchant::ItemsController < ApplicationController
  def index
    # Note at the end try to come back here and refactor using a call back?? So ultimately only one line in the index action.
    merchant = Merchant.find(params[:merchant_id])
    render json: MerchantItemSerializer.new(merchant.items)
  end
end