class Api::V1::Merchant::ItemsController < ApplicationController
  def index
    # Note at the end try to come back here and refactor using a call back?? So ultimately only one line in the index action.
    if Merchant.exists?(params[:merchant_id])
      # require 'pry'; binding.pry
      # render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
      items = Item.where(merchant_id: params[:merchant_id])
      render json: ItemSerializer.new(items)
    else
      render json: { error: "Merchant not found" }, status: 404
    end
    # require 'pry'; binding.pry
  end
end