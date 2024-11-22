from model.base import Base
from sqlalchemy import TEXT, VARCHAR, LargeBinary, Column

class User(Base):
    __tablename__ = "users"

    id = Column(TEXT, primary_key = True)
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)