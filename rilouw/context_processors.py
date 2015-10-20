import rilouw.settings

def settings(request):
    return {'STATIC_URL': rilouw.settings.STATIC_URL}
