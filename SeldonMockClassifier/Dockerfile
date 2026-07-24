# carefull as chainguard can change the version at any time
# free tier now - could use wolfi to be full open-source
FROM cgr.dev/chainguard/python:latest-dev AS builder
USER root
WORKDIR /app
ENV UV_PYTHON_INSTALL_DIR=/opt/python
RUN uv python install 3.12
COPY .python-version pyproject.toml uv.lock .
ENV UV_PROJECT_ENVIRONMENT=/opt/venv
RUN uv sync --frozen --no-dev --no-install-project --python-preference=only-managed
COPY --chown=nonroot:nonroot --chmod=744 MyModel.py ./training-and-model-package/model.joblib .
# Server Image
# carefull as chainguard can change the version at any time
# free tier now - could use wolfi to be full open-source
FROM cgr.dev/chainguard/python:latest
COPY --from=builder --chown=nonroot:nonroot /opt/python /opt/python
COPY --from=builder --chown=nonroot:nonroot /opt/venv /opt/venv
COPY --from=builder --chown=nonroot:nonroot /app /app
USER nonroot
WORKDIR /app
EXPOSE 5000
EXPOSE 9000
ENTRYPOINT ["/opt/venv/bin/seldon-core-microservice", "MyModel", "--service-type", "MODEL"]
