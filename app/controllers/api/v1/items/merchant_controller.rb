class Api::V1::Items::MerchantController < ApplicationController
  def index
    # require 'pry'; binding.pry
    # Note at the end try to come back here and refactor using a call back?? So ultimately only one line in the index action.
    # require 'pry'; binding.pry
    # require 'pry'; binding.pry
    # Edge Case = 
    
    if params.has_key?(:item_id) && !Item.exists?(params[:item_id])
      render json: { error: item.errors.full_messages }, status: :bad_request
    # Happy Path
    else
      item = Item.find(params[:item_id])
      render json: ItemsMerchantSerializer.new(item.merchant)
    end
  end
end