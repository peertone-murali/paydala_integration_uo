# Paydala platform integration with Operator's app

This is a reference implementation of the Operator mobile application that demonstrates how to integrate the Operator real mobile application with the Operator backend and Paydala payment platform. It includes sample code for the Operator reference  App (in Flutter) and  Operator backend for an operator such as UO with the home page as players wallet. Purpose of this app is to demonstrate the ease with which the given `WalletHomepageWidget` can be dropped in to the Operator's application to get Deposit and Withdraw function right out-of-the-box.  It is production ready in the sense it includes Flutter wrapper functions that help seamlessly transition from the debug version to release by merely building the app in the release mode. While in the debug mode, it bypasses using the operator backend by simulating backend functionality using Flutter functions, the same functions will route calls through operator server endpoints (sample implementation shown for Django) that are required to be run and exposed on the Operator's server once it is ready for production,

The reference application  demonstrates two principal operations namely  Deposit and Withdrawal. In the deposit flow, the player is presented with a screen that displays the list of possible deposit amounts and their equivalent in player coins. On selecting one of the items in the list, the equivalent money in USD is deposited using player's wallet on Paydala (created automatically on first deposit) and the  control returned to the Player's Operator wallet after depositing coins equivalent to the money deposited. Similarly, in the withdrawal flow, the player is presented with a screen to enter the coins to withdraw whose equivalent in USD (calculated as \<coins entered\>/100 in the sample code) is transferred to player's Paydala wallet (created during first Deposit) or to the bank account linked to that wallet.

The Operator reference app in Flutter is available under the **op\_app\_flutter** folder. It can be used as the starting point for integration by making changes as necessary to UI layout in the main.dart file to suit operator's app.  

Though details of Deposit and Withdraw sequence are provided in the following sections, it is primarilty meant to serve as a reference.  To get started, the Operator is not requied to write code to achieve the functionailty as it is already done in the reference app. 

## Deposit sequence

Sequence diagram for Deposit flow is shown below...

![Image alt text](https://github.com/PaydalaInc/paydala_integration_uo/blob/0b6a78ac027845b1149f52d00e89eefe3f0ca196/Paydala%20deposit%20flow.svg)

The diagram highlights the sequence of operations that are implemented in the reference app. There are essentially three blocks of operation that need to be performed for the flow to be fully effective. The first block shows setting up of the webhook handler to receive transaction details during both deposit and withdrawal operations. While it is possible to receive transaction confirmation through the Paydala widget, it is not always reliable as the app could crash etc. which breaks the flow.  In such an event, webhook confirmation is a reliable way to capture transactions for later verification. The second block shows the Deposit flow that involves deposit of USD into Operator's Paydala account from the Player's Paydala wallet using player's Card or Bank accounts. The third block refers to two ways of handling errors. 


## Withdraw sequence
Sequence diagram for withdrawal is given below...

![Image alt text](https://github.com/PaydalaInc/paydala_integration_uo/blob/70afa6dec27225768252ff5bb07ae489f3fda60b/Paydala%20withdraw%20flow.svg)
 
Withdrawal is achieved using Paydala API's that can be called from the Operator backend. Unlike Deposit, it does not require the Paydala Wallet UI. The amount to be withdrawn is transferred directly from Operator account on Paydala to the player's wallet on Paydala through a call to a single API.

# Integration steps


1. Contact Paydala to get an operator account on the sandbox / production server.
1. Obtain the **clientId** and **Shared secred / API keys** through the Paydala Operator portal and initialize the app. To do that, open the file named **op\_server\_api.dart** under the **lib/src** folder and initialize values for `CLIENT_ID`, `SECRET` variables with the ones obtained through the operator portal.
1. Build and run the flutter application in the Debug mode to get most of the functionality working. For testing and debugging conveniece, the need for the operator backend is circumvented by using Flutter functions that mimic operator backend services. Please note this is for testing and debugging purposes only. For production use, the app needs to be built in the Release mode to make the same functions use of the endpoints running operator backend for greater security. Follow the setps below to setup and run those endpoints on the oerator server. 
1. Once production ready, extend operator backend by including the code provided under **op_backend** for use with the production wallet app.  To do that for the Django server, copy the folder **op\_backend/python/op\_server\_django/op\_server** to your Django project and modify the project configuration to expose the endpoints included in the **views.py** file. Similarly, copy the **util** folder from **op\_backend/python/op\_server\_django** to the Operator's Django project folder. Once done, open the **\_\_init__.py** file under the **util** folder and replace the values of  `CLIENT_ID` and `SECRET` variables with those obtained in Step 2. The description of those endpoints are given in the next section for reference.
1. Once the operator server is extended with the endpoints, the Flutter app needs to be configured accordingly. To do that, open the file named **op\_server\_api.dart** under **lib/src** and change the `opBaseUrl` to point to the server that implements the above endpoints.
1. Set up the webhook configuration in the Paydala operator portal. In the portal, go to Settings -> Webhook and configure the URL of the webhook to point to the handler that receives transaction notifications. Sample webhook is included in the code that is already running on the operator backend set up  Step 3. The name of the webhook endpoint is webhookConfirmation. The URL to supply for the configuration is {opBaseUrl}/webhookConfirmation where opBaseUrl is the one set up in Step 4.
1. The included webhook endpoint merely validates the call by verifying the signature and displays the payload. Modify the endpoint to suit your requirement.

	
# Operator server endpoint reference

To integrate the Operator app with paydala platform, the operator needs to implement four endpoints on their server (Django server) by incorporating the code provided under the **op\_backend / python / op\_server\_django** folder...

Specifically, UO backend server should host the code given in the file **op\_server / views.py** to get these endpoints up and running. However, before copying the code into the **Django** **views**, the operator needs to implement just the authorization scheme to secure those endpoints. Once done, the rest of the logic can be customized using the provided template. Essentially, it is a server written in **Django** to serve as the gateway for accessing Paydala services. The boiler plate code to perform that is included. 

As mentioned earlier, the sample implementation of these endpoints are included in the project. They can be used directly after adding the operator's chosen authentication scheme. In most cases, these endpoints merely receive data from the Operator app and route it to paydala endpoints by adding access credentials required to access paydala endpoints. The endpoints used for deposit and withdrawal flow are listed below...
	
	
## `getSignedCreds`
This is an end point that wraps any payload sent from the operator app (as JSON) with the operator credentials and returns the unified  payload for use in other endpoints. The purpose is to avoid doing this on the operator app as it involves the use of Shared Secret / API Key which can be hacked. The signed payload is used  to securely transmit sensitive operator and user information to paydala server.  Consequently, it is an endpoint that should be implemented on the operator backend which has exclusive access to the API key. The code for this endpoint is included for use in the Django project. The endpoint wraps payload with operator details such as **client\_id**, **category\_id**, **region**, **timestamp** and creates unified credentials (`creds`, `signature`, `timestamp`). Necessary for the identifyOperator, login, guest\_login services on Paydala backend, this is also required in withdrawal flow to transmit the payload that includes sensitive customerId, requestId, user bank details. Here again, the operator credentials are in included in the wrapper while the user details are embedded in the payload section of the signed creds.  

## `webhookConfirmation`
As mentioned above, this endpoint is hosted on the operator server to receive transaction confirmations. Sample code for this endpoint is included in the project. 

## `getTxnStatus`
This is perhaps the most important endpoint which should be hosted on the operator's server using the sample code supplied in the project. This is essentially a gateway that is used to access paydala service using operator credentials for authorization to retrieve transaction information. The sample needs to be customized to secure the endpoint with the operator's chosen authorization scheme like JWT / OAuth etc. The primary purpose of this endpoint is to get the status of transaction after it is initiated. It requires two parameters, one to specify the reference type and the other transaction reference. Depending on the reference type the transaction reference is used to fetch various details (eg. transaction status that signify success, failure, partial, progress besides others).

## `sendMoney`
This endpoint is to move money from the operator account to the player account in case of withdrawal and distribution of winnings. It is a universal function that can be used to transfer money to players wallet or the player's bank account depending on the type of payload included in the call. The use of this is demonstrated in the withdrawal flow of the refernce application. Here again, the user / player credentials are wrapped with the operator credentials, signed and sent to paydala endpoints to securely move money. 

# License
The code is released under MIT license. Please read the terms of the license to understand the scope of use. 







