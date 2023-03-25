FROM python:3.9-slim-buster

WORKDIR /app

COPY app.py .
COPY Pipfile .
COPY Pipfile.lock .

RUN pip install --upgrade pip
RUN pip install pipenv==2022.5.2
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

ENV PATH=".venv/bin:$PATH"

CMD [ "python", "app.py" ]
