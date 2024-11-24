from fastapi import FastAPI
from routes import auth
from model.base import Base
from database import dbEngine

app = FastAPI()
app.include_router(auth.router, prefix='/auth')





Base.metadata.create_all(dbEngine)
    

































# Request
# from pydantic import BaseModel

# class Test(BaseModel):
#     name:str
#     age:int

# @app.get('/')
# def test():
#     return "Hello World"

# @app.post('/')
# def test(t:Test, q:str):
#     print(t)
#     return f'Hello World'

