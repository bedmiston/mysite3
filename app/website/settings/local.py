"""
Django settings for website project.

For more information on this file, see
https://docs.djangoproject.com/en/1.7/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.7/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
from .base import *
# import uwsgi
# from uwsgidecorators import timer
# from django.utils import autoreload
#
# @timer(3)
# def change_code_graceful_reload(sig):
#     if autoreload.code_changed():
#         uwsgi.reload()

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

TEMPLATE_DEBUG = True

# Application definition
# INSTALLED_APPS += (
#     'debug_toolbar',
# )
