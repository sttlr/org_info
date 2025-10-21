FROM python:3.13-alpine
LABEL maintainer="sttlr"

RUN adduser -h /app -g app -D app

WORKDIR /app

COPY requirements.txt /app

RUN apk add --no-cache bash postgresql-libs
RUN apk add --no-cache --virtual .builddeps build-base postgresql-dev
RUN pip install -r requirements.txt
RUN apk del --no-cache .builddeps

COPY . /app
RUN chown -R app:app /app
USER app

RUN mkdir -p databases

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["--help"]
