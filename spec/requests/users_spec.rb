require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    context '正常系' do
      context '正しいパラメータの場合' do
        let (:user_params) do
          {
            name: 'takara',
            email: 'test@test.com',
            password: 'password',
            password_confirmation: 'password'
          }
        end

        let (:user) { User.find_by(email: user_params[:email]) }
        let (:user_count) { User.count }

        it '200のステータスが返る' do
          post '/users', params: { user: user_params }
          expect(response).to have_http_status(200)
        end

        it 'ユーザーが1人追加されている' do
          expect{ post '/users', params: { user: user_params } }.to change{ User.count }.by(1)
        end

        it '登録後、正しい入会特典ポイントが付与されている' do
          post '/users', params: { user: user_params }
          expect(user.point).to eq(User::REGISTRATION_REWARD_POINT)
        end
      end
    end

    context '異常系' do
      context '異なるパスワードの場合' do
        let (:user_params_different_password) do
          {
            name: 'takara',
            email: 'test@test.com',
            password: 'password',
            password_confirmation: 'different_password'
          }
        end

        it '400のステータスが返る' do
          post '/users', params: { user: user_params_different_password }
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
