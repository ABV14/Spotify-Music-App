from fastapi import APIRouter, File, Form,  UploadFile, Depends
from database import get_db
from sqlalchemy.orm import Session
from middleware import auth_middleware
import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url
import uuid

from model.song import Song

router = APIRouter()


# Configuration       
cloudinary.config( 
    cloud_name = "doiju1dqr", 
    api_key = "487838519347777", 
    api_secret = "5oY7g_5MqW0_AfxAXtZJWLAHvm0", # Click 'View API Keys' above to copy your API secret
    secure=True
)

# # Upload an image
# upload_result = cloudinary.uploader.upload("https://res.cloudinary.com/demo/image/upload/getting-started/shoes.jpg",
#                                            public_id="shoes")
# print(upload_result["secure_url"])

# # Optimize delivery by resizing and applying auto-format and auto-quality
# optimize_url, _ = cloudinary_url("shoes", fetch_format="auto", quality="auto")
# print(optimize_url)

# # Transform the image: auto-crop to square aspect_ratio
# auto_crop_url, _ = cloudinary_url("shoes", width=500, height=500, crop="auto", gravity="auto")
# print(auto_crop_url)


### Convert color to HexCode
@router.post('/upload', status_code=201)
def upload_song(song:UploadFile = File(...), 
                thumbnail:UploadFile = File(...), 
                artist:str = Form(...), 
                   song_name:str = Form(...), 
                  hex_code:str = Form(...), 
                  db:Session = Depends(get_db),
                  auth_dict = Depends(auth_middleware.middleware)
                  ):
    
    print('song',song)
    print('thumbnail',thumbnail)
    print('artist',artist)
    print('hex_code',hex_code)
    print('song_name',song_name)
    # print('color',color)

    song_id = str(uuid.uuid4())
    song_result = cloudinary.uploader.upload(song.file, resource_type = 'auto', folder = f'songs/{song_id}')
    thumbnail_result = cloudinary.uploader.upload(thumbnail.file, resource_type = 'image', folder = f'songs/{song_id}')

    new_song = Song(
        id = song_id,
        songUrl = song_result['url'],
        artist_name = artist,
        thumbnail_url = thumbnail_result['url'],
        song_name = song_name,
        hexcode = hex_code
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)

    return new_song