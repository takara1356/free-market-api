require 'rails_helper'

RSpec.describe 'Items', type: :request do
  describe 'POST /items' do
    let!(:user) { FactoryBot.create(:user) }
    let(:headers) {{ 'Authorization': "Bearer #{user.token}" }}
    let(:item_params) do
      {
        item_info: {
          name: "SQLアンチパターン 第2版",
          description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
          price: 1200
        }
      }
    end

    context '正常系' do
      context '正しいパラメータの場合' do
        it '200のステータスが返る' do
          post '/item', params: item_params, headers: headers
          expect(response).to have_http_status(200)
        end

        it 'ユーザーに紐付く商品が1点追加されている' do
          expect{ post '/item', params: item_params, headers: headers }.to change{ user.items.count }.by(1)
        end

        it '追加した商品のステータスが販売中になっている' do
          post '/item', params: item_params, headers: headers
          expect(user.items.first.status_id).to eq(Status.on_sale_id)
        end
      end
    end

    context '異常系' do
      context '商品名が入力されていない場合' do
        let(:item_params_with_no_item_name) do
          {
            item_info: {
              name: "",
              description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
              price: 1200
            }
          }
        end

        it '400のステータスを返す' do
          post '/item', params: item_params_with_no_item_name, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/item', params: item_params_with_no_item_name, headers: headers }.to change{ user.items.count }.by(0)
        end
      end

      context '価格が300円以下の場合' do
        let(:item_params_with_less_than_minimum_amount) do
          {
            item_info: {
              name: "SQLアンチパターン 第2版",
              description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
              price: 299
            }
          }
        end

        it '400のステータスを返す' do
          post '/item', params: item_params_with_less_than_minimum_amount, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/item', params: item_params_with_less_than_minimum_amount, headers: headers }.to change{ user.items.count }.by(0)
        end
      end

      context '商品価格が整数でない場合' do
        let(:item_params_with_no_integer_price) do
          {
            item_info: {
              name: "SQLアンチパターン 第2版",
              description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
              price: 300.5
            }
          }
        end

        it '400のステータスを返す' do
          post '/item', params: item_params_with_no_integer_price, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/item', params: item_params_with_no_integer_price, headers: headers }.to change{ user.items.count }.by(0)
        end
      end

    end
  end
end
