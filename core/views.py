from django.http import JsonResponse
from django.http import HttpResponse
from PIL import Image, ImageDraw, ImageFont
import face_recognition
import base64
import random
import io
import os




def process_images(request):
    if request.method == 'POST':
        person_photo = request.FILES.get("imageFile1")
        group_photo = request.FILES.get("imageFile2")

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
        width, height = pil_image.size

        match_count = 0
        for (top, right, bottom, left), face_encoding, landmarks in zip(group_face_locations, group_face_encodings,
                                                                        group_face_landmarks):
            matches = face_recognition.compare_faces([person_face_encoding], face_encoding, tolerance=.48)

            # If match
            if True in matches:
                match_count += 1
                first_match_index = matches.index(True)

                # Draw box around face
                draw.rectangle(((left - 5, top - 5), (right + 5, bottom + 5)), outline=(0, 255, 0), width=4)

                # Get the confidence level and print it below the box
                confidence = face_recognition.face_distance([person_face_encoding], face_encoding)[first_match_index]
                confidence_percentage = round((1 - confidence) * 100, 2)
                draw.text((left, bottom + 10), f"Confidence: {confidence_percentage}%", fill=(0, 255, 0),
                          font=ImageFont.truetype("arial.ttf", 28))

        if match_count < 1:
            # Write "No matches found" on image
            font_ratio = 1 / 10
            font_size = int(min(pil_image.size) * font_ratio)
            font = ImageFont.truetype("arial.ttf", font_size)
            color = (255, 0, 0, 255)
            message = "No matches found"
            text_image = Image.new('RGBA', (width, height), (255, 255, 255, 120))
            text_draw = ImageDraw.Draw(text_image)
            text_width, text_height = text_draw.textsize(message, font)
            x = (width - text_width) / 2
            y = (height - text_height) * .9
            text_draw.text((x, y), message, font=font, fill=color)
            pil_image = pil_image.convert('RGBA')
            pil_image = Image.alpha_composite(pil_image, text_image)

        # Save the image to a buffer
        buf = io.BytesIO()
        pil_image.save(buf, format='PNG')
        image_data = base64.b64encode(buf.getvalue()).decode("utf-8")
        del draw

        # Return image
        response = HttpResponse(content_type='image/png')
        response.write(image_data)
        return response


def random_face(request):
    if request.method == 'GET':
        # specify the folder containing the preset photos
        presets_folder = 'static/presets/'


        # get a list of all folders in the presets folder
        preset_folders = [f for f in os.listdir(presets_folder) if os.path.isdir(os.path.join(presets_folder, f))]

        # randomly choose one of the preset folders
        selected_folder = random.choice(preset_folders)

        # get the path to the selected folder
        folder_path = os.path.join(presets_folder, selected_folder)

        # get a list of all photos in the selected folder
        photos = [f for f in os.listdir(folder_path) if os.path.isfile(os.path.join(folder_path, f))]

        # find the photo that matches the folder name
        person_photo = os.path.join(folder_path, selected_folder + '.jpg')

        # find the photo that ends with 'group'
        group_photo = ''
        for photo in photos:
            if photo.endswith(' Group.jpg'):
                group_photo = os.path.join(folder_path, photo)
                break

        person_photo = person_photo.replace('\\', '/')
        group_photo = group_photo.replace('\\', '/')

        # create a JSON response with the photo URLs
        data = {'person_photo': person_photo, 'group_photo': group_photo}
        return JsonResponse(data)

