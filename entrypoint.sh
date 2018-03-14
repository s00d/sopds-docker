#!/bin/bash

set -e 


function init_settings(){
    python3 manage.py migrate
    python3 manage.py sopds_util clear
    #python3 manage.py createsuperuser
    python3 -c "import os
os.environ['DJANGO_SETTINGS_MODULE'] = 'sopds.settings'
import django
django.setup()
from django.contrib.auth.management.commands.createsuperuser import get_user_model
if get_user_model().objects.filter(username='${SOPDS_USER}'): 
    print('Super user already exists. SKIPPING...')
else:
    print('Creating super user...')
    get_user_model()._default_manager.db_manager('default').create_superuser(username='${SOPDS_USER}', email='${SOPDS_EMAIL}', password='${SOPDS_PASSWORD}')
    print('Super user created...')"
    python3 manage.py sopds_util setconf SOPDS_ROOT_LIB '/books'
    python3 manage.py sopds_util setconf SOPDS_LANGUAGE ${SOPDS_LANG}
    python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY True
    touch inited.flag
}

case "$1" in
server)
    if [ ! -f inited.flag ]; then
        echo 'wait mysql init'
        #wait mysql
        sleep 10
        echo 'first init ...'
        init_settings
    fi
    python3 manage.py sopds_server start
    ;;
scaner)
    python3 manage.py sopds_scanner start
    ;;
log)
    tail -f \
        $(python3 manage.py sopds_util getconf SOPDS_SERVER_LOG) \
        $(python3 manage.py sopds_util getconf SOPDS_SCANNER_LOG)
    ;;
*)
    "$@"
    ;;
esac