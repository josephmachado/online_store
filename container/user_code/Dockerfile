FROM python:3.7-slim

# Checkout and install dagster libraries needed to run the gRPC server
# exposing your repository to dagit and dagster-daemon, and to load the DagsterInstance

RUN pip install \
    dagster==0.14.3 \
    dagster-postgres==0.14.3 \
    dagster-docker==0.14.3 \
    requests==2.27.1 \
    psycopg2-binary==2.9.3 \
    boto3==1.21.21 \
    dagster-dbt==0.14.3 \
    dbt==0.21.1

# Add repository code

WORKDIR /opt/dagster/app
ENV PYTHONPATH=/app

COPY ../../app /opt/dagster/app

# Run dagster gRPC server on port 4000

EXPOSE 4000

# CMD allows this to be overridden from run launchers or executors that want
# to run other commands against your repository
CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "-f", "repository.py"]