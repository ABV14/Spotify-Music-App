from fastapi import Depends, HTTPException, Header
import bcrypt
from middleware import auth_middleware
from model.user import User
from pydantic_schemas.user_create import UserCreate
import uuid
import bcrypt
from fastapi import APIRouter
from database import get_db
from sqlalchemy.orm import Session
import jwt
from pydantic_schemas.user_login import UserLogin

router = APIRouter()


@router.post('/signup', status_code=201)
def signup_user(user:UserCreate, db:Session = Depends(get_db)):
    # '''
    # Extract the data receiving from the body field
    # 1. Check if user in Db
    
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(400,'User with this email already exists!')
        return 
    
    #Add user
    hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email = user.email, password = hashed_password, name = user.name)
    
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user:UserLogin, db:Session = Depends(get_db)):
    #Check if user with same email already exists
    user_details = db.query(User).filter(User.email == user.email).first()
    if not user_details:
        raise HTTPException(400, "User with this email does not exist!")
    
    #Passwod matching or not
    is_match = bcrypt.checkpw(user.password.encode(), user_details.password)
    if not is_match:
        raise HTTPException(403, "Incorrect Password!")
    
    token = jwt.encode({'id': user_details.id}, 'password_key')
    return { 'token':token, 'user':user_details}

@router.get('/')
def getUserData(db:Session = Depends(get_db), user_dict = Depends(auth_middleware.middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()
    if not user:
        raise HTTPException(404, 'User not found')
    return user 