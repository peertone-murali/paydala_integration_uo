import datetime
import hmac
import hashlib
import json
from . import CLIENT_ID, SECRET_KEY


class SignedCreds ():
    creds: str
    signature: str
    payload: str

    def __init__(self, payload):
        self.payload = payload
        self.sign()

    def sign(self):
        timestamp = datetime.datetime.now().strftime(
            '%Y-%m-%d %H:%M:%S.%f')[:-3]
        
        creds_map = {
            "ver" : "1.0",
            "clientId" : CLIENT_ID,
            "categoryId" : "1",
            "region" : "USA",
            "timeStamp" : timestamp
            }

        creds_map['payload'] = json.loads(self.payload)

        self.creds = json.dumps(creds_map)
        print(self.creds)

        self.signature = hmac.new(SECRET_KEY.encode(), self.creds.encode(), hashlib.sha256).hexdigest()
        return

def get_signature(message : str):
    return hmac.new(SECRET_KEY.encode(), message.encode(), hashlib.sha256).hexdigest()


class SignedCredsEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, SignedCreds):
            return {"creds": obj.creds, "signature": obj.signature}
        return json.JSONEncoder.default(self, obj)


if __name__ == "__main__":
    signed_creds = SignedCreds('{ "name":"John", "age":30, "city":"New York"}')
    print("signature :", signed_creds.signature, "\ncreds = ", signed_creds.creds)

    # a Python object (dict):
    user_details = {
        "firstName": "John",
        "middleName": "William",
        "lastName": "Deere",
        "customerId": "1",
        "email": "john.deere@test.com",
        "dob": "10/22/2000",
        "ssl4": "3456",
        "streetAddress": "123 Elm st",
        "addressCity": "Big city",
        "addressState": "Tx",
        "addressZip": "56060",
        "addressCountry": "USA",
        "mobilePh": "4023345676"
    }

    # convert into JSON:
    y = json.dumps(user_details)
    signed_creds = SignedCreds(y)
    print("signature :", signed_creds.signature, "\ncreds = ", signed_creds.creds)
    json_data = json.dumps(signed_creds, cls=SignedCredsEncoder, indent=4)
    print(json_data)
    cjson = json.loads(json_data)
    # cjson = json.load(sCreds.creds)
    new_creds = cjson["creds"]
    new_signature = cjson["signature"]
    if new_signature == get_signature(new_creds):
        print("signature matched...!!!")



