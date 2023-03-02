import Header from "./components/Header";
import UploadBox from "./components/UploadBox";
import {useState} from "react";
import DownloadButton from "./components/DownloadButton";
import HomeButton from "./components/HomeButton";

function App() {
  const [imageData, setImageData] = useState(null);

  return (
    <div className="app-window">
      <header>
        <Header />
      </header>
      {imageData ? (
        <div>
          <div className="button-container">
            <DownloadButton imageData={imageData}/>
            <HomeButton />
          </div>
          <div className="imageData-container">
            <img src={imageData} alt="" />
          </div>
        </div>
        ) : (
          <div className="upload-container">
            <UploadBox setImageData={setImageData} />
          </div>
      )}
    </div>
  );
}


export default App;

