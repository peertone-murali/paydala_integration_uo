import requests

url = "http://localhost:8000/txn-details"
payload = {"refType": 2, "txnRef": "123456"}

response = requests.post(url, json=payload)

if response.status_code == 200:
    data = response.json()
    print("Response payload:")
    print(data)
else:
    print("Error:", response.content)
