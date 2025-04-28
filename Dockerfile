FROM python:3.12-slim as builder

RUN pip install --upgrade pip
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM python:3.12-slim

LABEL maintainer="Przemek Zbiciak"

COPY --from=builder /install /usr/local
COPY app.py /app/app.py

WORKDIR /app

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD python -c "import socket; s=socket.socket(); s.settimeout(2); s.connect(('localhost', 5000))"

EXPOSE 5000

CMD ["python", "app.py"]