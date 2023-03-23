
import sys
from http.client import HTTPException
# from urllib.request import Request
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import json
import logging
from fastapi import FastAPI, Header, HTTPException
from hashlib import sha256
from datetime import datetime
import hmac

sys.path.append('..')  # Add parent directory to path
from signedcreds.signedcreds import *

API_SECRET_KEY = SECRET_KEY

app = FastAPI()

# Initialize a logger object
logger = logging.getLogger("my_logger")

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(content={"error": exc.detail}, status_code=exc.status_code)

@app.get('/')
def hello():
    return {'message': 'Hello, World!'}


@app.post('/getSignedCreds')
async def get_signed_creds(request: Request):
    payload_bytes = await request.body()
    if len(payload_bytes) == 0:
        raise HTTPException(400, "Missing or empty payload")
    payload_str = payload_bytes.decode("utf-8")
    print("payload = ",payload_str) 
    try:
        x = json.loads(payload_str)
    except Exception as e:
        logger.error(f"Error loading JSON: {e}")
        raise HTTPException(400, "Malformed JSON payload")
    creds = SignedCreds(payload_str)
    return {"creds":creds.creds, "signature" : creds.signature }
    # return json.dumps(creds, cls=SignedCredsEncoder)

# from fastapi import FastAPI


@app.post("/getTxnStatus")
async def txn_details(payload: dict):
    ref_type = payload.get("refType")
    txn_ref = payload.get("txnRef")

    # Dummy data for txnDetails
    txn_details = [
        {"txnRef": "abcdef", "status": "processing", "currencyId": 1, "amount": 10, "timeStamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")},
        {"txnRef": "ghijkl", "status": "success", "currencyId": 1, "amount": 20, "timeStamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")}
    ]

    # Prepare the response payload
    response = {
        "result": "partial",
        "refType": ref_type,
        "txnRef": "3b524d4-c254-11ed-afa1-0242ac120002",
        "timeStamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f"),
        "txnDetails": txn_details
    }

    return response


@app.post("/webhookConfirmation")
async def webhook_confirmation(payload: dict, X_Request_Signature: str = Header(None)):
    if X_Request_Signature is None:
        raise HTTPException(status_code=400, detail="X-Request-Signature header is missing")
    
    # Create the signature using the API_SECRET_KEY and the payload
    signature = hmac.new(API_SECRET_KEY.encode(), json.dumps(payload).encode(), sha256).hexdigest()

    # Compare the signature in the X-Request-Signature header with the calculated signature
    if not hmac.compare_digest(signature, X_Request_Signature):
        raise HTTPException(status_code=400, detail="Invalid signature")
    
    # If the signature is valid, print the payload
    print(payload)
    
    return {"message": "Webhook confirmed"}



if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)

