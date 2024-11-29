from model.base import Base
from sqlalchemy import Column, TEXT, VARCHAR

class Song(Base):
    __tablename__ = 'songs'
    id = Column(TEXT,primary_key=True)
    songUrl = Column(TEXT)
    artist_name = Column(TEXT)
    thumbnail_url = Column(TEXT)
    song_name = Column(VARCHAR(100))
    hexcode = Column(VARCHAR(6))
    