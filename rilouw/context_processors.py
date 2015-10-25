# -*- coding: utf-8 -*-
# 
# Rilouw.eu website by Jérôme Martin
# 魚室会社 Fishroom Corp. is a fictional company

import rilouw.settings

def settings(request):
    return {
        'STATIC_URL': rilouw.settings.STATIC_URL,
        'SITE_DESCRIPTION': 'An IT project manager\'s minimalist and clear resume',
        'SITE_KEYWORDS': 'jérôme martin, jerome martin, project manager, information technology, management, risk management, manager, resume, scrum, agile, pmi, django, python',
        'SITE_AUTHOR': 'Jérôme Martin'
    }
