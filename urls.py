# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

from django.conf.urls import patterns, include, url

urlpatterns = patterns(
    '',

    # Supermodule configuration
    url('', include('rilouw.urls')),
)
