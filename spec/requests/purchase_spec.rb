require 'rails_helper'

RSpec.describe 'Purchase', type: :request do
  describe 'POST /items/:id/purchase' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:item) { FactoryBot.create(:item) }
    let(:headers) {{ 'Authorization': "Bearer #{user.token}" }}
    let(:throw_request) { post "/items/#{item.id}/purchase", headers: headers }

    before do
      user.items << item
    end

    context '正常系' do
      context '正しいパラメータの場合' do
        it '200のステータスが返る' do
          throw_request
          expect(response).to have_http_status(200)
        end

        it '商品のステータスが売り切れになっている' do
          throw_request
          expect(item.reload.status_id).to eq(Status.sold_out_id)
        end

        it '購入したユーザーのポイントが商品の値段分消費されている' do
          throw_request
          expect{ user.reload }.to change{ user.point }.by(-item.price)
        end

        it '売買履歴が1件登録されている' do
          expect{ throw_request }.to change{ Order.count }.by(1)
        end

        it '売買履歴に正しい情報が追加されている' do
          throw_request
          expect(user.orders.last.item_id).to eq(item.id)
          expect(user.orders.last.purchased_user_id).to eq(user.id)
        end
      end
    end

    context '異常系' do
      context 'ポイントが不足している場合' do
        before do
          user.point = 0
          user.save
        end

        it '400のステータスを返す' do
          throw_request
          expect(response).to have_http_status(400)
        end

        it '商品のステータスが販売中である' do
          throw_request
          expect(item.reload.status_id).to eq(Status.on_sale_id)
        end

        it '購入したユーザーのポイントが消費されていない' do
          throw_request
          expect{ user.reload }.to change{ user.point }.by(0)
        end

        it '売買履歴の数が変わっていない' do
          expect{ throw_request }.to change{ Order.count }.by(0)
        end
      end

      context '商品が売り切れの場合' do
        before do
          item.status_id = Status.sold_out_id
          item.save
        end

        it '400のステータスを返す' do
          throw_request
          expect(response).to have_http_status(400)
        end

        it '購入したユーザーのポイントが消費されていない' do
          throw_request
          expect{ user.reload }.to change{ user.point }.by(0)
        end

        it '売買履歴の数が変わっていない' do
          expect{ throw_request }.to change{ Order.count }.by(0)
        end
      end
    end
  end
end
