from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+psycopg://postgres:abv@localhost:5432/fluttermusicapp"
dbEngine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit = False, autoflush=False, bind=dbEngine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()