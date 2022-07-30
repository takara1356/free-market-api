require 'rails_helper'

RSpec.describe 'Items', type: :request do
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

  describe 'POST /items' do
    context '正常系' do
      context '正しいパラメータの場合' do
        it '200のステータスが返る' do
          post '/items', params: item_params, headers: headers
          expect(response).to have_http_status(200)
        end

        it 'ユーザーに紐付く商品が1点追加されている' do
          expect{ post '/items', params: item_params, headers: headers }.to change{ user.items.count }.by(1)
        end

        it '追加した商品のステータスが販売中になっている' do
          post '/items', params: item_params, headers: headers
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
          post '/items', params: item_params_with_no_item_name, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/items', params: item_params_with_no_item_name, headers: headers }.to change{ user.items.count }.by(0)
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
          post '/items', params: item_params_with_less_than_minimum_amount, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/items', params: item_params_with_less_than_minimum_amount, headers: headers }.to change{ user.items.count }.by(0)
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
          post '/items', params: item_params_with_no_integer_price, headers: headers
          expect(response).to have_http_status(400)
        end

        it 'ユーザーに紐付く商品の数が変わらない' do
          expect{ post '/items', params: item_params_with_no_integer_price, headers: headers }.to change{ user.items.count }.by(0)
        end
      end
    end
  end

  describe 'PATCH /items' do
    # 事前に商品を登録しておく
    before do
      user.items << FactoryBot.create(:item)
    end

    let(:item) { user.items.last }

    context '正常系' do
      context '商品名を更新する場合' do
        let(:update_item_params_with_name) do
          {
            item_info: {
              # 版を更新
              name: "SQLアンチパターン 第3版",
              description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
              price: 1200
            }
          }
        end

        it '200のステータスが返る' do
          patch "/items/#{item.id}", params: update_item_params_with_name, headers: headers
          expect(response).to have_http_status(200)
        end

        it '商品名が更新される' do
          patch "/items/#{item.id}", params: update_item_params_with_name, headers: headers
          old_item_name = item.name
          expect(item.reload.name).not_to eq(old_item_name)
        end
      end

      context '商品説明を更新する場合' do
        let(:update_item_params_with_description) do
          {
            item_info: {
              name: "SQLアンチパターン 第2版",
              # 商品説明を更新
              description: "changed description",
              price: 1200
            }
          }
        end

        it '200のステータスが返る' do
          patch "/items/#{item.id}", params: update_item_params_with_description, headers: headers
          expect(response).to have_http_status(200)
        end

        it '商品説明が更新される' do
          patch "/items/#{item.id}", params: update_item_params_with_description, headers: headers
          old_item_description = item.description
          expect(item.reload.description).not_to eq(old_item_description)
        end
      end

      context '価格を更新する場合' do
        let(:update_item_params_with_price) do
          {
            item_info: {
              name: "SQLアンチパターン 第2版",
              description: "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
              # 価格を更新
              price: 1500
            }
          }
        end

        it '200のステータスが返る' do
          patch "/items/#{item.id}", params: update_item_params_with_price, headers: headers
          expect(response).to have_http_status(200)
        end

        it '価格が更新される' do
          patch "/items/#{item.id}", params: update_item_params_with_price, headers: headers
          old_item_price = item.price
          expect(item.reload.price).not_to eq(old_item_price)
        end
      end

      context '全てのパラメータを同時に更新する場合' do
        let(:update_item_params) do
          {
            item_info: {
              # 全てのパラメータを更新
              name: "SQLアンチパターン 第3版",
              description: "changed description",
              price: 1500
            }
          }
        end

        it '200のステータスが返る' do
          patch "/items/#{item.id}", params: update_item_params, headers: headers
          expect(response).to have_http_status(200)
        end

        it '全てのパラメータが更新される' do
          patch "/items/#{item.id}", params: update_item_params, headers: headers
          old_item_name = item.name
          old_item_description = item.description
          old_item_price = item.price
          expect(item.reload.name).not_to eq(old_item_name)
          expect(item.reload.description).not_to eq(old_item_description)
          expect(item.reload.price).not_to eq(old_item_price)
        end
      end
    end
  end

  describe 'delete /items' do
    let(:item) { user.items.last }

    context '正常系' do
      context '正しいパラメータの場合' do
        # 事前に商品を登録しておく
        before do
          user.items << FactoryBot.create(:item)
        end

        it '200のステータスが返る' do
          delete "/items/#{item.id}", headers: headers
          expect(response).to have_http_status(200)
        end

        it 'ユーザーに紐付く商品が1点削除されている' do
          expect{ delete "/items/#{item.id}", headers: headers }.to change{ user.items.count }.by(-1)
        end
      end
    end

    context '異常系' do
      context '存在しない商品IDを指定した場合' do
        before do
          # 商品を全て削除しておく
          Item.destroy_all
        end

        it '404のステータスが返る' do
          delete "/items/1", headers: headers
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
