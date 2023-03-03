function preview_image(event, preview_id) {
    var reader = new FileReader();
    reader.onload = function() {
        var output = document.getElementById(preview_id);
        output.src = reader.result;
        output.style.display = "block";
    }
    reader.readAsDataURL(event.target.files[0]);
}