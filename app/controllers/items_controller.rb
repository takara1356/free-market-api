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

  # 商品購入
  def purchase
    set_item(params['id'])

    # ユーザーのポイントが足りているか確認
    has_enough_point?

    # 商品が売り切れていないか確認
    item_is_on_sale?

    ActiveRecord::Base.transaction do
      # ユーザーのポイントを減らす
      consume_point

      # 商品の状態を売り切れにする
      @item.update_status_to_sold_out

      # 売買履歴を登録する
      Order.create!(purchased_user_id: @current_user.id, item_id: @item.id, sold_point: @item.price)
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

  def has_enough_point?
    if @current_user.point <= @item.price
      raise InvalidOperationError.new('ポイントが不足しています')
    end
  end

  def item_is_on_sale?
    if @item.status_id != Status.on_sale_id
      raise InvalidOperationError.new('商品は売り切れです')
    end
  end

  def consume_point
    @current_user.point -= @item.price
    @current_user.save!
  end
end
