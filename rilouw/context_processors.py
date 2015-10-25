# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

import rilouw.settings

def settings(request):
    return {
        'STATIC_URL': rilouw.settings.STATIC_URL,
        'SITE_DESCRIPTION': 'An IT project manager\'s minimalist and clear resume',
        'SITE_KEYWORDS': '',
        'SITE_AUTHOR': 'Jérôme Martin'
    }
