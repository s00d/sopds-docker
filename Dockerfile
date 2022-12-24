FROM python:3.7

LABEL   author="Dmitry Shelepnev admin@sopds.ru" \
        devops="Evgeny Stoyanov quick.es@gmail.com" \
        name="SOPDS books catalog" \
        url="https://github.com/s00d/sopds" \
        version="master"

ENV SOPDS_DIR="/opt" \
    SOPDS_LANG='ru-RU' \
    SOPDS_USER='admin' \
    SOPDS_PASSWORD='admin' \
    SOPDS_EMAIL='user@user.user'

COPY ./opt /opt
COPY entrypoint.sh ${SOPDS_DIR}/entrypoint.sh

RUN chmod +x ${SOPDS_DIR}/entrypoint.sh \
    && apt update \
    && apt install -y unzip \
    && apt install -y postgresql postgresql-client postgresql-contrib libpq-dev \
    && pip3 install psycopg2-binary==2.8.6 \
    && pip3 install -r ${SOPDS_DIR}/requirements.txt

#COPY settings.py ${SOPDS_DIR}/sopds/settings.py
VOLUME /opds
WORKDIR ${SOPDS_DIR}
ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "server" ]
