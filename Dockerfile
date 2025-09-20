FROM python:3.11-slim

WORKDIR /app

# Устанавливаем переменные окружения для неинтерактивного режима
ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем зависимости системы и Poetry
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && apt-get purge -y --auto-remove curl

ENV PATH="/root/.local/bin:$PATH"

# Копируем файлы Poetry
COPY pyproject.toml poetry.lock* ./

# Устанавливаем зависимости (без указания несуществующих групп)
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction

# Копируем код приложения
COPY . .

# Создаем пользователя для безопасности
RUN useradd -m -u 1000 appuser
USER appuser

# Открываем порт
EXPOSE 5000

# Запускаем приложение
CMD ["uvicorn", "main:app", "--port", "5000"]