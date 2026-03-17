FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

COPY . .

RUN git submodule update --init mini-swe-agent || true

RUN uv venv .venv --python 3.11
ENV VIRTUAL_ENV="/app/.venv"
ENV PATH="/app/.venv/bin:$PATH"

RUN uv pip install -e ".[all]" || pip install -e ".[all]"
RUN uv pip install -e "./mini-swe-agent" || true

CMD ["hermes", "gateway"]
