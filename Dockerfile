# `python-base` sets up all our shared environment variables
FROM python:3.13.1-slim AS python-base

    # python
ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=2.1.4 \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    # this is where our requirements + virtual environment will live
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"


# prepend poetry and venv to path
# 1. Ajuste do PATH (removemos o VENV_PATH que não vamos usar)
ENV PATH="$POETRY_HOME/bin:$PATH"

# 2. Instalação de dependências do sistema
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        libpq-dev \
        gcc

# 3. Instala o Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# 4. Configura o Poetry para instalar TUDO no Python global do container
RUN poetry config virtualenvs.create false

# 5. Define a pasta de trabalho como /app (a mesma do seu docker-compose)
WORKDIR /app

# 6. Copia os arquivos de dependência e instala
COPY poetry.lock pyproject.toml /app/
RUN poetry install --no-root

# 7. Copia o resto do código do seu projeto
COPY . /app/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]