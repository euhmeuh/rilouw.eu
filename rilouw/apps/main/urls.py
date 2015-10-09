"""main URL Configuration
"""

from django.conf.urls import include, url
from django.contrib import admin

from rilouw.apps.main.views import HomeView

urlpatterns = [
    url(r'^$', HomeView.as_view(), name='home'),
]
