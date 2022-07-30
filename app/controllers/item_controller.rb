class ItemController < ApplicationController
  before_action :authenticate_token

  # ユーザーによる商品出品
  def create
    item_params_hash = item_params.to_h
    item_params_hash.store('status_id', Status.on_sale_id)

    # トランザクション貼る
    ActiveRecord::Base.transaction do
      @item = @current_user.items.create!(item_params_hash)
    end

    render json: @item
  end

  private

  def item_params
    params.require(:item_info).permit(:name, :description, :price)
  end
end
