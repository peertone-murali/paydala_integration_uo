import sys
from django.http import JsonResponse, HttpRequest, HttpResponseBadRequest
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

import json
import hmac
from hashlib import sha256
import logging

sys.path.append('..')  # Add parent directory to path

from signedcreds.signedcreds import *

API_SECRET_KEY = SECRET_KEY

# Initialize a logger object
logger = logging.getLogger("my_logger")

@csrf_exempt
@require_POST
def get_signed_creds(request: HttpRequest):
    if request.method == 'POST':
        payload_bytes = request.body
        if len(payload_bytes) == 0:
            raise HttpResponseBadRequest("Missing or empty payload")
        payload_str = payload_bytes.decode("utf-8")
        print("payload = ",payload_str) 
        try:
            x = json.loads(payload_str)
        except Exception as e:
            logger.error(f"Error loading JSON: {e}")
            raise HttpResponseBadRequest("Malformed JSON payload")
        creds = SignedCreds(payload_str)
        return JsonResponse({"creds":creds.creds, "signature" : creds.signature})
    else:
        return JsonResponse({'message': 'Hello, World!'})

@csrf_exempt
@require_POST
def webhook_confirmation(request: HttpRequest):
    if request.method == 'POST':
        payload = json.loads(request.body)
        X_Request_Signature = request.headers.get('X-Request-Signature')
        if X_Request_Signature is None:
            raise HttpResponseBadRequest("X-Request-Signature header is missing")
        
        # Create the signature using the API_SECRET_KEY and the payload
        signature = hmac.new(API_SECRET_KEY.encode(), json.dumps(payload).encode(), sha256).hexdigest()
    
        # Compare the signature in the X-Request-Signature header with the calculated signature
        if not hmac.compare_digest(signature, X_Request_Signature):
            raise HttpResponseBadRequest("Invalid signature")
        
        # If the signature is valid, print the payload
        print(payload)
        
        return JsonResponse({"message": "Webhook confirmed"})
    else:
        return JsonResponse({'message': 'Hello, World!'})

