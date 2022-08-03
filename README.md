# README

## 開発環境構築

### 初回セットアップ(dockerイメージビルド&DB作成)

```
make setup
```

### テスト環境セットアップ

```
make setup-test
```

### コンテナ起動

```
make up
```

### コンテナ終了

```
make down
```

### テスト実行
```
make rspec
```

## API request sumple

#### create user(ユーザー登録)

`POST /users`

パラメータ例(curl)

```sh
curl --location --request POST 'localhost:3000/users' \
--header 'Content-Type: application/json' \
--data-raw '{
  "user": {
    "name": "testuser",
    "email": "test@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}'
```

#### login(ログイン)

`POST /login`

パラメータ例(curl)

```sh
curl --request POST 'localhost:3000/login' \
--header 'Content-Type: application/json' \
--data-raw '{
  "login_info": {
    "email": "test@example.com",
    "password": "password"
  }
}'

# response
# トークンが返ります(トークンの中身は'sample_token'で固定中)
{
  "token": "sample_token"
}
```

#### logout(ログアウト)

`GET /logout`

パラメータ例(curl)

```sh
# ログイン時に発行されたトークンを渡します
curl --request GET 'localhost:3000/logout' \
--header 'Authorization: Bearer sample_token'

# response
{
  "message": "ログアウトしました"
}
```

#### create item(商品登録)

`POST /items`

パラメータ例(curl)

```sh
curl --request POST 'localhost:3000/items' \
--header 'Authorization: Bearer sample_token' \
--header 'Content-Type: application/json' \
--data-raw '{
  "item_info": {
    "name": "SQLアンチパターン 第2版",
    "description": "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
    "price": 1500
  }
}'
```

#### update item(商品情報の更新)

`PATCH /items/:item_id`

パラメータ例(curl)

```sh
curl --request PATCH 'localhost:3000/items/1' \
--header 'Authorization: Bearer sample_token' \
--header 'Content-Type: application/json' \
--data-raw '{
  "item_info": {
    "name": "SQLアンチパターン 第3版",
    "description": "特に目立った汚れはありませんが、中古品であることをご理解の上ご購入お願い致します。",
    "price": 2000
  }
}'
```

#### delete item(商品の削除)

`DELETE /items/:item_id`

パラメータ例(curl)

```sh
curl --request DELETE 'localhost:3000/items/1' \
--header 'Authorization: Bearer sample_token'
```

#### purchase item(商品の購入)

`POST /items/:item_id/purchase`

パラメータ例(curl)

```sh
curl --request POST 'localhost:3000/items/1/purchase' \
--header 'Authorization: Bearer sample_token'
```
