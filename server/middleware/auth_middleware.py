#Get the user token from headers

from fastapi import HTTPException, Header
import jwt

def middleware(x_auth_token = Header()):
    try:
        if not x_auth_token:
            raise HTTPException(401, 'No auth token, access denied!')
        #decode the token
        verified_token = jwt.decode(x_auth_token,'password_key',['HS256'])
        if not verified_token:
                raise HTTPException(401, 'Token Verification failed, authorization denied')
        #id from the token
        uid = verified_token.get('id')
        return {'uid':uid, 'token':x_auth_token}
    #postgres database and get user information
    except jwt.PyJWTError:
        raise HTTPException(401, 'Token is not valid, Authorization failed')
    # pass