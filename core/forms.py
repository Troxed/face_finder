from django import forms

class UploadPhotosForm(forms.Form):
    person_photo = forms.ImageField(
        label='Face to search for',
        widget=forms.ClearableFileInput(attrs={'onchange': 'preview_image(event, "person-preview")'})
    )
    group_photo = forms.ImageField(
        label='Photo to search in',
        widget=forms.ClearableFileInput(attrs={'onchange': 'preview_image(event, "group-preview")'})
    )


