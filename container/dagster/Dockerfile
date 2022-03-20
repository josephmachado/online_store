# Dagster libraries to run both dagit and the dagster-daemon. Does not
# need to have access to any pipeline code.

FROM python:3.7-slim

RUN pip install \
    dagster==0.14.3 \
    dagster-graphql==0.14.3 \
    dagit==0.14.3 \
    dagster-postgres==0.14.3 \
    dagster-docker==0.14.3 \
    ipython_genutils==0.2.0

# Set $DAGSTER_HOME and copy dagster instance and workspace YAML there
ENV DAGSTER_HOME=/opt/dagster/dagster_home/

RUN mkdir -p $DAGSTER_HOME

COPY ../../dagster.yaml ../../workspace.yaml $DAGSTER_HOME

WORKDIR $DAGSTER_HOME