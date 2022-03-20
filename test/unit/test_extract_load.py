from dagster import build_op_context
from ops.extract_load import extract_customer_risk_score


def test_extract_customer_risk_score():
    context = build_op_context(
        op_config={"risk_endpoint": "http://risk_api:80"}
    )
    assert len(extract_customer_risk_score(context)) == 1000
