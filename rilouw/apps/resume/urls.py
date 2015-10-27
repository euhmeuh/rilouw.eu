# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

"""main URL Configuration
"""

from django.conf.urls import include, url

from rilouw.apps.resume.views import ResumeView, ContactView

urlpatterns = [
    url(r'^$', ResumeView.as_view(), name='resume'),
    url(r'^resume$', ResumeView.as_view(), name='resume'),
    #url(r'^contact$', ContactView.as_view(), name='resume-contact')
]
