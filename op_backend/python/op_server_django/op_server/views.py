import sys
from django.http import JsonResponse, HttpRequest, HttpResponseBadRequest
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

import json
import hmac
from hashlib import sha256
import logging


# from rest_framework.decorators import api_view

# import hashlib

# from datetime import datetime

sys.path.append('..')  # Add parent directory to path

from util.signedcreds import *

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


# @csrf_exempt
# @require_POST
# def txn_status(request):
#     # Extract the JSON payload from the request data
#     data = json.loads(request.body)

#     # Extract the required headers from the request
#     access_sign = request.headers.get('CB_ACCESS_SIGN')
#     access_timestamp = request.headers.get('CB_ACCESS_TIMESTAMP')
#     access_client_id = request.headers.get('CB_ACCESS_CLIENT_ID')

#     # Compute the HMAC signature using the access timestamp and payload
#     message = access_timestamp + json.dumps(data)
#     signature = hmac.new(
#         API_SECRET_KEY.encode(),
#         msg=message.encode(),
#         digestmod=sha256
#     ).hexdigest()

#     # Verify that the signature matches the one in the header
#     if signature != access_sign:
#         return JsonResponse({'error': 'Invalid access signature'})
    
#     # Compare the signature in the X-Request-Signature header with the calculated signature
#     if not hmac.compare_digest(signature, access_sign):
#         raise HttpResponseBadRequest("Invalid signature")

#     # Create the response payload
#     result = 'processed'
#     ref_type = int(data['refType'])
#     txn_ref = data['txnRef']
#     timestamp = datetime.utcnow().isoformat() + 'Z'
#     txn_details = [{
#         'txnRef': txn_ref,
#         'status': 'processed',
#         'currencyId': 1,
#         'amount': 10,
#         'timeStamp': timestamp,
#     }]
#     response_data = {
#         'result': result,
#         'refType': ref_type,
#         'txnRef': txn_ref,
#         'timeStamp': timestamp,
#         'txnDetails': txn_details,
#     }

#     return JsonResponse(response_data)




# url = 'https://dev-api.paydala.com/transactions/txnStatus'
# client_id = '6f5df04e484640e98e2310268b5dbbd4'
# secret_key = 'your-secret-key-here'

# payload = {
#     'refType': '1',
#     'txnRef': 'abcdef'
# }

# timestamp = int(datetime.now().timestamp())

# # Generate CB-ACCESS-SIGN header
# payload_string = json.dumps(payload)
# message = str(timestamp) + payload_string
# signature = hmac.new(secret_key.encode(), message.encode(), hashlib.sha256).hexdigest()

# headers = {
#     'CB-ACCESS-SIGN': signature,
#     'CB-ACCESS-TIMESTAMP': str(timestamp),
#     'CB-ACCESS-CLIENT-ID': client_id,
#     'Content-Type': 'application/json'
# }

# response = requests.post(url, headers=headers, json=payload)

# print(response.json())
