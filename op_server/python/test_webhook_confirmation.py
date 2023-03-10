import requests
import json
from hashlib import sha256
import hmac

API_SECRET_KEY = "your_api_secret_key_here"

payload = {
    "email": "john.smith@demora.org", 
    "amount": "10.0", 
    "txn_ref": "tlhATVL5U",
    "request_id": "ahsdhsdjhds"
}

# Create the signature using the API_SECRET_KEY and the payload
signature = hmac.new(API_SECRET_KEY.encode(), str(payload).encode(), sha256).hexdigest()

headers = {"X-Request-Signature": signature}

response = requests.post("http://localhost:8000/webhookConfirmation", json=payload, headers=headers)

print(response.json())