from django.contrib import admin
from django.urls import path, include
from .views import UploadPhotosView

app_name = "core"

urlpatterns = [
    path("", UploadPhotosView.as_view(), name="index"),
    path("admin/", admin.site.urls),
]