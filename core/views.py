from django.shortcuts import render, redirect
from django.views.generic.edit import FormView
from django.urls import reverse_lazy
from .forms import UploadPhotosForm

from PIL import Image, ImageDraw
import face_recognition
import base64
import io



class UploadPhotosView(FormView):
    template_name = 'core/index.html'
    form_class = UploadPhotosForm
    success_url = reverse_lazy('result')

    def form_valid(self, form):
        # Get the uploaded files from the form
        person_photo = form.cleaned_data['person_photo']
        group_photo = form.cleaned_data['group_photo']

        # Person encodings and landmarks
        person_photo = face_recognition.load_image_file(person_photo)
        person_face_location = face_recognition.face_locations(person_photo)
        person_face_encoding = face_recognition.face_encodings(person_photo, person_face_location, model='large')[0]
        person_face_landmarks = face_recognition.face_locations(person_photo)

        # Group encodings and landmarks
        group_photo = face_recognition.load_image_file(group_photo)
        group_face_locations = face_recognition.face_locations(group_photo)
        group_face_encodings = face_recognition.face_encodings(group_photo, group_face_locations)
        group_face_landmarks = face_recognition.face_landmarks(group_photo, group_face_locations)

        # Check for matches and draw boxes
        pil_image = Image.fromarray(group_photo)
        draw = ImageDraw.Draw(pil_image)

        for (top, right, bottom, left), face_encoding, landmarks in zip(group_face_locations, group_face_encodings,
                                                                        group_face_landmarks):
            matches = face_recognition.compare_faces([person_face_encoding], face_encoding, tolerance=.48)

            # If match
            if True in matches:
                first_match_index = matches.index(True)

                # Draw box around face
                draw.rectangle(((left - 5, top - 5), (right + 5, bottom + 5)), outline=(0, 255, 0), width=3)

        # Save the image to a buffer
        buf = io.BytesIO()
        pil_image.save(buf, format='PNG')
        image_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')



        del draw

        # Redirect to the result page
        return render(self.request, 'core/result.html', {'image': image_base64})


