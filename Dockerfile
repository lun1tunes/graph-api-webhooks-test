FROM python:3.11-slim

WORKDIR /app

# Устанавливаем зависимости системы
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем Poetry
ENV POETRY_HOME=/opt/poetry
RUN curl -sSL https://install.python-poetry.org | python3 - \
    && cd /usr/local/bin && ln -s /opt/poetry/bin/poetry

# Копируем файлы Poetry
COPY pyproject.toml poetry.lock* ./

# Устанавливаем зависимости
RUN poetry install --only main --no-interaction --no-ansi

# Копируем код приложения
COPY . .

# Создаем пользователя для безопасности
RUN useradd -m -u 1000 appuser
USER appuser

# Открываем порт
EXPOSE 5000

# Запускаем приложение
CMD ["uvicorn", "main:app", "--port", "5000"]
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]