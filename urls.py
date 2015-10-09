from django.conf.urls import patterns, include, url

urlpatterns = patterns(
    '',

    # Supermodule configuration
    url('', include('rilouw.urls')),
)
