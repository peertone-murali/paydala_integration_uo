# Steps to integrate UO app with Paydala

This is the reference implementation for integrating the Operator App (mobile), Operator backend with the Paydala payment platform. It includes sample code for the reference Operator App (in Flutter) such as UO assuming the player starts from the Wallet. It also includes code for server endpoints (in python) to be included in the Operator backend. 

## Deposit 

Sequence diagram for Deposit flow...
![](https://github.com/PaydalaInc/paydala_integration_uo/blob/ca8feaad6dd9b44f4850564323f3b40205c1719c/Paydala%20deposit%20flow-Op.svg)

### Server endpoints

To integrate using this flow, the operator needs to implement two endpoints on their backend...

1. getSignedCreds(payload)
1. webhookConfirmation(email, amount, txn_ref, request_id)

UO server can add the logic given in the file op_server.py  under the op_server/python folder to get these endpoints up and running. Essentially, it is a server written in FastAPI and it can be included directly (or used as a reference) in the Operator backend by initializing clientId and sharedSecred with values obtained from the Operator portal.  

### Flutter mobile app

Also, find included in the op_app_flutter folder the Flutter reference app that can be used as the basis for implementing the Wallet landing page in the Operator app to handle Deposit and Withdraw flows of Paydala.  The code demonstrates parts of the deposit flow and also shows how to send Operator specific user data (payload) to the Paydala Flutter widget.

