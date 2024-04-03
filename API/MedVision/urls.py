from django.urls import path, include
from rest_framework import routers
from MedVision import views

router = routers.DefaultRouter()
router.register(r'bodyparts', views.BodyPartViewSet, 'bodyparts')

urlpatterns = [
    path('api/v1/', include(router.urls)),
]