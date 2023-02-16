#Создаем базовый образ
FROM python:3.9-alpine as build

#Доустанавливаем нужные пактеы
RUN apk add --no-cache postgresql-libs
RUN apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev

RUN pip install Flask psycopg2-binary configparser

#Создем основной образ
FROM python:3.9-alpine as production

#создаем нужный катлог
RUN mkdir -p /srv/app/conf
COPY web.conf /srv/app/conf/
COPY web.py /srv/app/
#копируем библиотечные файлы из базового образа
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

WORKDIR /srv/app
#Запскаем скрипт на исполнение
CMD ["python", "web.py"]
