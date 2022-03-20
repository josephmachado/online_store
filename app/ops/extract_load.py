from typing import Dict, List

import boto3
import psycopg2.extras as p
import requests
from dagster import op
from utils.config import (
    get_aws_creds,
    get_customer_db_creds,
    get_warehouse_creds,
)
from utils.db import WarehouseConnection


@op(config_schema={"risk_endpoint": str})
def extract_customer_risk_score(context) -> List[Dict[str, int]]:
    resp = requests.get(context.op_config["risk_endpoint"])
    return resp.json()


@op
def load_customer_risk_score(customer_risk_score: List[Dict[str, int]]):
    ins_qry = """
    INSERT INTO store.customer_risk_score(
        customer_id,
        risk_score
    )
    VALUES (
        %(customer_id)s,
        %(risk_score)s
    )
    """
    with WarehouseConnection(get_warehouse_creds()).managed_cursor() as curr:
        p.execute_batch(curr, ins_qry, customer_risk_score)


@op(config_schema={"orders_bucket_name": str})
def extract_orders_data(context) -> List[Dict[str, str]]:
    s3 = boto3.client("s3", **get_aws_creds())
    objs = s3.list_objects_v2(Bucket=context.op_config["orders_bucket_name"])[
        "Contents"
    ]

    def get_last_modified(obj) -> int:
        return int(obj["LastModified"].strftime("%s"))

    last_added = [
        obj["Key"] for obj in sorted(objs, key=get_last_modified, reverse=True)
    ][0]

    obj = s3.get_object(
        Bucket=context.op_config["orders_bucket_name"], Key=last_added
    )
    data = obj["Body"].read().decode("utf-8")

    orders = []
    for line in data.split("\n")[:-1]:
        order_id, customer_id, item_id, item_name, delivered_on = str(
            line
        ).split(",")
        orders.append(
            {
                "order_id": order_id,
                "customer_id": customer_id,
                "item_id": item_id,
                "item_name": item_name,
                "delivered_on": delivered_on,
            }
        )

    return orders


@op
def load_orders_data(orders_data: List[Dict[str, str]]):
    ins_qry = """
    INSERT INTO store.orders(
        order_id,
        customer_id,
        item_id,
        item_name,
        delivered_on
    )
    VALUES (
        %(order_id)s,
        %(customer_id)s,
        %(item_id)s,
        %(item_name)s,
        %(delivered_on)s
    )
    """
    with WarehouseConnection(get_warehouse_creds()).managed_cursor() as curr:
        p.execute_batch(curr, ins_qry, orders_data)


@op
def extract_customer_data() -> List[Dict[str, str]]:
    with WarehouseConnection(get_customer_db_creds()).managed_cursor() as curr:
        curr.execute(
            '''
            select customer_id,
                first_name,
                last_name,
                state_code,
                datetime_created,
                datetime_updated
            from customers
            where
            TO_TIMESTAMP(datetime_created, 'YY-MM-DD HH24:MI:ss')
             >= current_timestamp - interval '5 minutes'
            or TO_TIMESTAMP(datetime_updated, 'YY-MM-DD HH24:MI:ss')
             >= current_timestamp - interval '5 minutes'
            '''
        )
        cust_data = curr.fetchall()
    return [
        {
            "customer_id": str(d[0]),
            "first_name": str(d[1]),
            "last_name": str(d[2]),
            "state_code": str(d[3]),
            "datetime_created": str(d[4]),
            "datetime_updated": str(d[5]),
        }
        for d in cust_data
    ]


@op
def load_customer_data(customer_data: List[Dict[str, str]]):
    ins_qry = """
    INSERT INTO store.customers(
        customer_id,
        first_name,
        last_name,
        state_code,
        datetime_created,
        datetime_updated
    )
    VALUES (
        %(customer_id)s,
        %(first_name)s,
        %(last_name)s,
        %(state_code)s,
        %(datetime_created)s,
        %(datetime_updated)s
    )
    """
    with WarehouseConnection(get_warehouse_creds()).managed_cursor() as curr:
        p.execute_batch(curr, ins_qry, customer_data)
