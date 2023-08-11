import React, { useState, useEffect } from "react";
import ImageInputBox from "./ImageInputBox";
import RandomFaceButton from "./RandomFaceButton";
import FindFaceButton from "./FindFaceButton";
import { FadeLoader } from "react-spinners";


const UploadBox = ({ setImageData }) => {
  const [image1, setImage1] = useState(null);
  const [image2, setImage2] = useState(null);
  const [imageFile1, setImageFile1] = useState(null);
  const [imageFile2, setImageFile2] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [csrfToken, setCsrfToken] = useState('');


  useEffect(() => {
    fetch('/get_csrf_token/')
      .then(response => response.json())
      .then(data => setCsrfToken(data.csrfToken))
      .catch(error => console.error('Error fetching CSRF token:', error));
  }, []);


  const handleFindFace = () => {
    const formData = new FormData();
    formData.append("imageFile1", imageFile1);
    formData.append("imageFile2", imageFile2);
    setIsLoading(true);

    fetch("/process_images/", {
      method: "POST",
      headers: {
        "X-CSRFToken": csrfToken,
      },
      body: formData,
    })
      .then((response) => {
        setIsLoading(false);
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.text();
      })
      .then((base64Image) => {
        setImageData(`data:image/png;base64,${base64Image}`);
      })
      .catch((error) => {
        setIsLoading(false);
        console.error("Error processing images:", error);
      });
  };

  const handleRandomFace = () => {
    const token = getCookie('csrftoken');
    fetch("/random_face/", {
      method: "GET",
      headers: {
        "X-CSRFToken": token,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        setImage1(data.person_photo);
        setImage2(data.group_photo);

        // Fetch the images and convert them to blobs
        Promise.all([
          fetch(data.person_photo).then((res) => res.blob()),
          fetch(data.group_photo).then((res) => res.blob()),
        ]).then(([personBlob, groupBlob]) => {
          // Create new File objects and set state
          const personFile = new File([personBlob], "person_photo.png");
          const groupFile = new File([groupBlob], "group_photo.png");
          setImageFile1(personFile);
          setImageFile2(groupFile);
        });
      })
      .catch((error) => {
        console.error("Error getting random face:", error);
      });
  };

  function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(";").shift();
  }


  return (
    <div className="upload-box">
    {isLoading && (
      <div className="loading-container">
        <FadeLoader size={100} color={"#1745ff"} loading={isLoading} />
      </div>
    )}
      <div className="images-box">
        <div className={`image-input-box ${isLoading ? 'loading' : ''}`}>
          <ImageInputBox title="Face to find" image={image1} setImageFile={setImageFile1} setImage={setImage1}/>
        </div>
        <div className={`image-input-box ${isLoading ? 'loading' : ''}`}>
          <ImageInputBox title="Photo to search" image={image2} setImageFile={setImageFile2} setImage={setImage2}/>
        </div>
      </div>
      <div className='button-container'>
        <RandomFaceButton onClick={handleRandomFace} />
      </div>
      <div className='button-container'>
        <FindFaceButton onClick={handleFindFace} />
      </div>
    </div>
  );
};

export default UploadBox;

