up:
	docker compose up --build -d

down:
	docker compose down --volumes

clean-dashboard:
	rm -rf metabase-data/metabase.db

restart: down up

format:
	docker exec formatter python -m black -S --line-length 79 .

isort:
	docker exec formatter isort .

pytest:
	docker exec formatter pytest /code/test

type:
	docker exec formatter mypy --ignore-missing-imports /code

lint: 
	docker exec formatter flake8 /code 

ci: isort format type lint pytest