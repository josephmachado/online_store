"""
create customer customer_risk_store tables
"""

from yoyo import step

__depends__ = {"20221022_01_G4MS0-create-store-schema"}

steps = [
    step(
        """
    CREATE TABLE store.customers (
        customer_id INTEGER,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        state_code VARCHAR(2),
        datetime_created VARCHAR(100),
        datetime_updated VARCHAR(100),
        datetime_inserted TIMESTAMP not null default CURRENT_TIMESTAMP
    )
    """,
        "DROP TABLE store.customers",
    ),
    step(
        """
    CREATE TABLE store.customer_risk_score(
        customer_id INTEGER,
        risk_score INTEGER,
        datetime_inserted TIMESTAMP not null default CURRENT_TIMESTAMP
    )
    """,
        "DROP TABLE store.customer_risk_score",
    ),
]
