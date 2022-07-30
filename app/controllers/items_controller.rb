class ItemsController < ApplicationController
  before_action :authenticate_token

  # ユーザーによる商品出品
  def create
    item_params_hash = item_params.to_h
    item_params_hash.store('status_id', Status.on_sale_id)

    ActiveRecord::Base.transaction do
      @item = @current_user.items.create!(item_params_hash)
    end

    render json: @item
  end

  # 商品更新
  def update
    set_item(params['id'])

    ActiveRecord::Base.transaction do
      @item.update!(item_params)
    end

    render json: @item
  end

  # 商品削除
  def delete
    set_item(params['id'])

    ActiveRecord::Base.transaction do
      @item.destroy!
    end

    render json: { message: 'success' }
  end

  private

  def item_params
    params.require(:item_info).permit(:name, :description, :price)
  end

  def set_item(id)
    @item = Item.find_by!(id: id)
  end
end
