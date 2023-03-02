function ImageInputBox({ title, image, setImage, setImageFile }) {
  const handleChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImageFile(file);
      const reader = new FileReader();
      reader.onload = () => {
        setImage(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };


  return (
    <div style={{textAlign: 'center'}}>
      <h2>
        { title }
      </h2>
      <div className="image-input-container">
        <input type="file" accept="image/*" onChange={handleChange}/>
        {image ? (
          <img
            src={image}
            alt={`Preview`}
            style={{ maxWidth: '100%', maxHeight: '100%' }}
          />
        ) : (
          <span>Select image</span>
        )}
      </div>
    </div>
  );
}

export default ImageInputBox;
