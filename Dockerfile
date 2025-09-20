FROM python:3.11-slim

WORKDIR /app

# Устанавливаем зависимости системы и Poetry
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

# Копируем файлы Poetry
COPY pyproject.toml poetry.lock* ./

# Устанавливаем зависимости без установки текущего проекта
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-dev --no-interaction --no-ansi

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