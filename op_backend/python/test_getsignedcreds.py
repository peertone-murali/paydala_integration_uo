import requests
from requests.structures import CaseInsensitiveDict
from util.signedcreds import *
from util import *
import json
from urllib.parse import urljoin

url = urljoin(pd_base_url,"/getSignedCreds")

headers = CaseInsensitiveDict()
headers["Content-Type"] = "application/json"

data = """{
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
"""


resp = requests.post(url, headers=headers, data=data)

resp_str  = resp.content.decode("utf-8")

creds_map = json.loads(resp_str)
print("resp : ", json.dumps(creds_map,indent=4))
signature = get_signature(creds_map["creds"])
if creds_map["signature"] == signature :
    print("signature matched...!")

# print('httpStatus = ',resp.status_code,'resp = ', resp.content)
