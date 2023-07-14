class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.find_item_by_name(params[:name]).first

    if item
      render json: ItemSerializer.new(item)
    else
      render json: ItemSerializer.new(Item.new)
    end
  end
end