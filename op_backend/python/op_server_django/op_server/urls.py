from django.urls import path
from . import views

urlpatterns = [
    # path('getSignedCreds', views.get_signed_creds, name='get_signed_creds'),
    path('getSignedCreds', views.get_signed_creds, name='get_signed_creds'),
    path('webhookConfirmation', views.webhook_confirmation, name='webhook_confirmation'),
]
