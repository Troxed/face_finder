from django import forms

class UploadPhotosForm(forms.Form):
    person_photo = forms.ImageField(label='Upload a photo of the person')
    group_photo = forms.ImageField(label='Upload a photo of the group')

