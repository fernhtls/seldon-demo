FROM ghcr.io/astral-sh/uv:python3.12-trixie
# Package installation
WORKDIR /app
COPY .python-version pyproject.toml uv.lock .
RUN uv sync --locked
# RUN .venv/bin/activate.sh
COPY *.py .
RUN chown -R 8888 /app
# Exposing ports
EXPOSE 5000
EXPOSE 9000
# Model Env vars - can be modified on run time
ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["seldon-core-microservice", "MyModel", "--service-type", "MODEL"]
