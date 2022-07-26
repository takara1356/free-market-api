Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  # ユーザー関連
  post 'users' => 'users#create'

  # ログイン
  post 'login' => 'auth#login'

  # ログアウト
  get 'logout' => 'auth#logout'

  # 商品出品
  post 'items' => 'items#create'

  # 商品情報更新
  patch 'items/:id' => 'items#update'

  # 商品削除
  delete 'items/:id' => 'items#delete'

  # 商品購入
  post 'items/:id/purchase' => 'items#purchase'
end
