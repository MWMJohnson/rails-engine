class Api::V1::Items::MerchantController < ApplicationController
  def index
    if params[:item_id].present? && !Item.exists?(params[:item_id])
      render json: { error: "Item not found" }, status: 404
    else
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(item.merchant)
    end
  end
end