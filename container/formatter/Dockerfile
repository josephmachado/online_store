FROM python:3.9.5

# set up location of code
WORKDIR /code
ENV PYTHONPATH=/code/app

# install python requirements
ADD container/formatter/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# copy repo
COPY ../../ /code/

ENTRYPOINT ["tail", "-f", "/dev/null"]
