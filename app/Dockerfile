FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

FROM python:3.11-slim
RUN useradd --no-create-home --uid 10001 newuser
ENV PYTHONPATH=/app
WORKDIR /app
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/local/bin /usr/local/bin
COPY --from=build /app /app
RUN chown -R newuser:newuser /app
USER newuser
EXPOSE 8080
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
