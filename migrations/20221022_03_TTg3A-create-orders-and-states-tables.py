"""
create orders and states tables
"""

from yoyo import step

__depends__ = {"20221022_02_Dwqjh-create-customer-customer-risk-store-tables"}

steps = [
    step(
        """
    CREATE TABLE store.orders(
        order_id VARCHAR(50),
        customer_id INTEGER,
        item_id VARCHAR(50),
        item_name VARCHAR(150),
        delivered_on VARCHAR(50)
    )
    """,
        "DROP TABLE store.orders",
    ),
    step(
        """
    CREATE TABLE store.states  (
        state_identifier INTEGER,
        state_code VARCHAR(2),
        st_name VARCHAR(30)
    )
    """,
        "DROP TABLE store.states",
    ),
]
