# Data engineering project: data extraction to analysis

For more details read the blog [here](https://www.startdataengineering.com/post/data-engineering-project-e2e/)

# Architecture diagram

![Architecture](/assets/images/arch.png)
# Running the project

## Prerequisites

1. [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) v1.27.0
2. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Clone the repo using

```bash
git clone https://github.com/josephmachado/online_store.git
cd online_store
```

## Spin up

In your project directory run the following command.

```bash
make up
docker ps # to see all the components
```

Wait for about a minute. You can log into

1. Dagster UI at [http://localhost:3000/](http://localhost:3000/)
2. Metabase UI at [http://localhost:3001/](http://localhost:3001/). Use the following credentials

```bash
username: james.holden@rocinante.com
password: password1234
```

Make sure to switch on the data pipeline in dagster UI, and let it run a few times. In Metabase UI, search for and click on `Online store overview` using the search bar on the top left corner. This will take you to the dashboard which is fed with the transformed data from the data pipeline.

## Tear down

When you are done, you can spin down your containers using the following command.

```bash
make down
```

## References

1. [Dagster docs](https://docs.dagster.io/tutorial)
2. [Metabase docs](https://www.metabase.com/learn/getting-started/getting-started.html)
3. [FastAPI docker](https://fastapi.tiangolo.com/deployment/docker/)
4. [Dagster docker setup](https://github.com/dagster-io/dagster/tree/0.14.17/examples/deploy_docker)
5. [dbt docs](https://docs.getdbt.com/)