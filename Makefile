.PHONY: build restart up up-with-db down downv bundle-install rspec railsc migrate app log seed create-db setup setup-db

build:	## アプリイメージをビルドします
	@docker-compose build

restart:	down up## 起動中のコンテナを再起動します

up:	## コンテナを起動します
	@docker-compose up -d

up-with-db:	## コンテナを起動します
	@docker-compose up -d db

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

seed:
	@docker-compose run --rm app rails db:seed

create-db:
	@docker-compose run --rm app rails db:create

setup: bundle-install	up-with-db	create-db	migrate	seed ## 初回セットアップを実行します

setup-test:	## データベースを初期化します
	@docker-compose run --rm app rails db:create RAILS_ENV=test
	@docker-compose run --rm app rails ridge:apply RAILS_ENV=test
	@docker-compose run --rm app rails db:seed RAILS_ENV=test
