import requests
import json
from hashlib import sha256
import hmac
from signedcreds import *

API_SECRET_KEY = SECRET_KEY

#baseUrl = "https://5cb6-49-207-225-253.in.ngrok.io"
baseUrl = "http://34.171.255.136:8000"
payload = {
    "email": "john.smith@demora.org", 
    "amount": "10.0", 
    "txn_ref": "tlhATVL5U",
    "request_id": "ahsdhsdjhds"
}

# Create the signature using the API_SECRET_KEY and the payload
# payloadStr = json.dumps(payload,ensure_ascii=False)
payloadStr = json.dumps(payload)
signature = hmac.new(API_SECRET_KEY.encode(), payloadStr.encode(), sha256).hexdigest()
# print(payloadStr)
payload_dict = json.loads(payloadStr)

headers = {"X-Request-Signature": signature, "Content-Type": "application/json"}

response = requests.post(baseUrl + "/webhookConfirmation", data=payloadStr, headers=headers)

# print("signature = ",signature)
# print("httpStatus = ",response.status_code)
print(response.json())
