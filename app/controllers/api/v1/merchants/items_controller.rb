class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    if Merchant.exists?(params[:merchant_id])
      items = Item.where(merchant_id: params[:merchant_id])
      render json: ItemSerializer.new(items)
    else
      render json: { error: "Merchant not found" }, status: 404
    end
  end
end