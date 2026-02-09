FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt
COPY . .

FROM python:3.11-slim
RUN useradd --no-create-home --uid 10001 newuser
ENV PYTHONPATH=/app
WORKDIR /app
COPY --from=build /root/.local /root/.local
COPY --from=build /app /app
ENV PATH=/root/.local/bin:$PATH
User newuser
EXPOSE 8080
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
