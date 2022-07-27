.PHONY: build restart up down downv bundle-install rspec railsc migrate app log

build:	## アプリイメージをビルドします
	@docker-compose build

restart:	down up## 起動中のコンテナを再起動します

up:	## コンテナを起動します
	@docker-compose up -d

down:	## コンテナを終了します
	@docker-compose down

downv:	## コンテナを終了してボリュームも削除します
	@docker-compose down -v

bundle-install:	## bundle installを実行します
	@docker-compose run --rm app bundle install

rspec:	## テストを実行します
	@docker-compose run --rm -e RAILS_ENV=test app rspec

railsc:	## Rails Consoleを起動します
	@docker-compose run --rm app rails c

migrate:	## マイグレーションを実行します
	@docker-compose run --rm app rails ridge:apply

runner:	## シェルを起動します
	@docker-compose run --rm app /bin/bash

log:	## 全てのログを表示します
	@docker-compose logs -f
