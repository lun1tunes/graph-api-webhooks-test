FROM python:3.11-slim

WORKDIR /app

# Устанавливаем переменные окружения
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

# Устанавливаем зависимости системы
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

# Копируем файлы зависимостей
COPY pyproject.toml poetry.lock* ./

# Устанавливаем Python зависимости
RUN poetry config virtualenvs.create false && \
    poetry install --no-root --no-interaction

# Копируем код приложения
COPY . .

# Открываем порт
EXPOSE 5000

# Запускаем приложение (важно использовать ту же команду, что и в коде)
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]