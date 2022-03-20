from random import randint

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    # cust_id, risk_score [1-100]
    risk_data = [
        {"customer_id": randint(1, 10000), "risk_score": randint(1, 100)}
        for _ in range(1000)
    ]
    return risk_data
