Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # ユーザー関連
  post 'users' => 'users#create'

  # ログイン
  post 'login' => 'auth#login'

  # 商品出品
  post 'items' => 'items#create'

  # 商品情報更新
  patch 'items/:id' => 'items#update'
end
