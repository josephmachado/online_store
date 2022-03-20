from dagster import repository
from jobs.online_store_data_ingestion import online_store_data_ingestion
from schedules.online_store_data_ingestion_schedule import (
    online_store_data_ingestion_schedule,
)


@repository
def deploy_docker_repository():
    return [online_store_data_ingestion, online_store_data_ingestion_schedule]
