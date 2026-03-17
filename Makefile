DEV_COMPOSE=docker compose -f docker-compose.dev.yml

dev:
	$(DEV_COMPOSE) up --build

down:
	$(DEV_COMPOSE) down

restart:
	$(DEV_COMPOSE) down && $(DEV_COMPOSE) up --build

console:
	$(DEV_COMPOSE) exec backend rails console

migrate:
	$(DEV_COMPOSE) exec backend rails db:migrate

create-db:
	$(DEV_COMPOSE) exec backend rails db:create

generate:
	$(DEV_COMPOSE) exec backend rails g $(name)

rails: 
	$(DEV_COMPOSE) exec backend rails $(command)
test:
	$(DEV_COMPOSE) exec -e RAILS_ENV=test backend bundle exec rspec $(file)

logs:
	$(DEV_COMPOSE) logs -f

ps:
	$(DEV_COMPOSE) ps

psql:
	$(DEV_COMPOSE) exec db psql -U postgres
swagger:
	$(DEV_COMPOSE) exec -e RAILS_ENV=test backend bundle exec rails rswag:specs:swaggerize
storybook:
	$(DEV_COMPOSE) exec frontend npm run storybook