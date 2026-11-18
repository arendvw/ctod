FROM python:3.13-slim

WORKDIR /app

ENV GDAL_CACHEMAX=75%
ENV GDAL_DISABLE_READDIR_ON_OPEN=TRUE
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES=YES
ENV GDAL_HTTP_MULTIPLEX=YES
ENV GDAL_INGESTED_BYTES_AT_OPEN=32768
ENV GDAL_HTTP_VERSION=2
ENV CPL_VSIL_CURL_ALLOWED_EXTENSIONS=tif,tiff,vrt,cog
ENV VSI_CACHE=TRUE


COPY pyproject.toml poetry.lock /app/
COPY ./ctod /app/ctod/
COPY ./scripts /app/scripts/
COPY start_server.py /app/

# All native dependencies ship cp313 wheels, so no compiler is needed.
RUN apt-get update \
    && apt-get upgrade -y \
    && pip install "poetry>=2,<3" \
    && poetry config virtualenvs.create false \
    && poetry install --only main \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

CMD ["python", "start_server.py"]
