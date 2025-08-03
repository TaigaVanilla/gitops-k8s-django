#!/bin/sh
set -e

python manage.py collectstatic --noinput

exec gunicorn --bind 0.0.0.0:8000 --workers 3 --timeout 120 library_management_system.wsgi:application
