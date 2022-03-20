from dagster import job
from dagster_dbt import dbt_cli_resource, dbt_run_op, dbt_test_op
from ops.extract_load import (
    extract_customer_data,
    extract_customer_risk_score,
    extract_orders_data,
    load_customer_data,
    load_customer_risk_score,
    load_orders_data,
)

my_dbt_resource = dbt_cli_resource.configured(
    {
        "project_dir": "./transform",
        "profiles_dir": "./transform",
    }
)

run_config = {
    "ops": {
        "extract_customer_risk_score": {
            "config": {"risk_endpoint": "http://risk_api:80"}
        },
        "extract_orders_data": {
            "config": {"orders_bucket_name": "app-orders"}
        },
    }
}


@job(resource_defs={"dbt": my_dbt_resource}, config=run_config)
def online_store_data_ingestion():
    dbt_test_op(
        dbt_run_op(
            [
                load_customer_risk_score(extract_customer_risk_score()),
                load_customer_data(extract_customer_data()),
                load_orders_data(extract_orders_data()),
            ]
        )
    )
