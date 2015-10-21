# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

from rilouw.common.views import BaseView

class HomeView(BaseView):
    template_name = "main/home.jade"
