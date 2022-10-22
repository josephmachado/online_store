docker-spin-up:
	docker compose up --build -d

sleeper:
	sleep 15

up: docker-spin-up sleeper warehouse-migration

down:
	docker compose down --volumes

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

####################################################################################################################
# Set up cloud infrastructure
tf-init:
	terraform -chdir=./terraform init

infra-up:
	terraform -chdir=./terraform apply

infra-down:
	terraform -chdir=./terraform destroy

infra-config:
	terraform -chdir=./terraform output

####################################################################################################################
# Datawarehouse migration

db-migration:
	@read -p "Enter migration name:" migration_name; docker exec formatter yoyo new ./migrations -m "$$migration_name"

warehouse-migration:
	docker exec formatter yoyo develop --no-config-file --database postgres://sde:password@warehouse_db:5432/warehouse ./migrations

warehouse-rollback:
	docker exec -it formatter yoyo rollback --no-config-file --database postgres://sde:password@warehouse_db:5432/warehouse ./migrations

####################################################################################################################
# Port forwarding to local machine

cloud-dagster:
	terraform -chdir=./terraform output -raw private_key > private_key.pem && chmod 600 private_key.pem && ssh -o "IdentitiesOnly yes" -i private_key.pem ubuntu@$$(terraform -chdir=./terraform output -raw ec2_public_dns) -N -f -L 3001:$$(terraform -chdir=./terraform output -raw ec2_public_dns):3000 && open http://localhost:3001 && rm private_key.pem

cloud-metabase:
	terraform -chdir=./terraform output -raw private_key > private_key.pem && chmod 600 private_key.pem && ssh -o "IdentitiesOnly yes" -i private_key.pem ubuntu@$$(terraform -chdir=./terraform output -raw ec2_public_dns) -N -f -L 3002:$$(terraform -chdir=./terraform output -raw ec2_public_dns):3001 && open http://localhost:3002 && rm private_key.pem

####################################################################################################################
# Helpers

ssh-ec2:
	terraform -chdir=./terraform output -raw private_key > private_key.pem && chmod 600 private_key.pem && ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i private_key.pem ubuntu@$$(terraform -chdir=./terraform output -raw ec2_public_dns) && rm private_key.pem