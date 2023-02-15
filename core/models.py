from django.db import models

class PersonPhoto(models.Model):
    photo = models.ImageField(upload_to='person_photos/')

class GroupPhoto(models.Model):
    photo = models.ImageField(upload_to='group_photos/')

class ResultPhoto(models.Model):
    photo = models.ImageField(upload_to='result_photos/')
