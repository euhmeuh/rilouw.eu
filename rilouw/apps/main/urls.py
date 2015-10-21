# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

"""main URL Configuration
"""

from django.conf.urls import include, url

from rilouw.apps.main.views import HomeView

urlpatterns = [
    url(r'^$', HomeView.as_view(), name='home'),
]
