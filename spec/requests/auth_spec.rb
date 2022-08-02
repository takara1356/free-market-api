require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'POST /login' do
    let (:user_params) do
      {
        name: 'takara',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    let (:res_json) { JSON.parse(response.body) }
    let (:user) { User.find_by(email: user_params[:email]) }

    context '正常系' do
      context '正しいパラメータの場合' do
        let (:login_params) do
          {
            login_info: {
              email: user_params[:email],
              password: user_params[:password]
            }
          }
        end

        before do
          User.create(user_params)
        end

        it '200のステータスが返る' do
          post '/login', params: login_params
          expect(response).to have_http_status(200)
        end

        it 'トークンが発行される' do
          post '/login', params: login_params
          expect(res_json['token']).to be_truthy
        end

        it '発行されたトークンとユーザーに紐付くトークンが一致する' do
          post '/login', params: login_params
          expect(res_json['token']).to eq(user.token)
        end
      end
    end

    context '異常系' do
      context 'ログインユーザーのメールアドレスが存在しない場合' do
        let (:login_params_with_not_exists_user) do
          {
            login_info: {
              email: 'not_exists_user@test.com',
              password: 'password'
            }
          }
        end

        it '400のステータスが返る' do
          post '/login', params: login_params_with_not_exists_user
          expect(response).to have_http_status(400)
        end

        it '正しいエラーメッセージが返る' do
          post '/login', params: login_params_with_not_exists_user
          expect(res_json['error']['message']).to eq(AuthenticationError::DEFAULT_MESSAGE)
        end
      end

      context 'ログインユーザーのパスワードが間違っている場合' do
        let (:login_params_with_incorrect_password) do
          {
            login_info: {
              email: 'test@test.com',
              password: 'incorrect_password'
            }
          }
        end

        before do
          User.create(user_params)
        end

        it '400のステータスが返る' do
          post '/login', params: login_params_with_incorrect_password
          expect(response).to have_http_status(400)
        end

        it '正しいエラーメッセージが返る' do
          post '/login', params: login_params_with_incorrect_password
          expect(res_json['error']['message']).to eq(AuthenticationError::DEFAULT_MESSAGE)
        end
      end
    end
  end
end
