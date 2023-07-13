class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update 
    if item_params.has_key?(:merchant_id) && !Merchant.exists?(Merchant.find(params[:merchant_id]).id)
      render json: Merchant.error.full_messages
    else
      item = Item.find(params[:id])
      item.update(item_params)
      render json: ItemSerializer.new(item)
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    render json: ItemSerializer.new(item)
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end