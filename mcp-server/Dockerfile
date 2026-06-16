FROM python:3.12-alpine

RUN apk add --no-cache postgresql-dev gcc musl-dev

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt psycopg[c]

COPY server.py .

EXPOSE 8000
CMD ["python", "server.py"]
