import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_app_flutter/src/op_server_api.dart';
import 'package:op_app_flutter/src/paydala_flutter_widget.dart';
import 'package:op_app_flutter/src/payload.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';
import 'package:op_app_flutter/src/signedcreds.dart';
// import 'package:op_app_flutter/src/utils.dart';
// import 'package:op_app_flutter/src/paydala_webview.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Wallet App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: WalletHomePage(),
//       routes: {
//         '/wallet': (context) => WalletHomePage(),
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? CupertinoApp(
            title: 'Wallet App',
            theme: CupertinoThemeData(
              primaryColor: Colors.blue,
            ),
            home: WalletHomePage(),
            routes: {
              '/wallet': (context) => WalletHomePage(),
            },
          )
        : MaterialApp(
            title: 'Wallet App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: WalletHomePageStatefulWidget(), //WalletHomePage(),
            routes: {
              '/wallet': (context) =>
                  WalletHomePageStatefulWidget(), //WalletHomePage(),
            },
          );
  }
}

class WalletHomePage extends StatelessWidget {
  final int balance = 1500;

  void processTransaction(Object txnObject) {
    if (txnObject is TransactionResponse) {
      print("TransactionResponse: ${txnObject.toJson()}");
    } else if (txnObject is TransactionDetails) {
      print("ChannelEvent: ${txnObject.toJson()}");
    } else {
      print("Unknown object type");
    }
  }

  const WalletHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Coins $balance',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OperatorDepositScreen(
                            onTransaction: processTransaction)));
                // MaterialPageRoute(
                //   builder: (context) => PaydalaFlutterWidget(
                //       title: "Deposit using Paydala",
                //       url: "https://flutter.dev",
                //       payload: '{"email" : "john.doe@test.com"}'),
                // ));
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_upward),
                  // SizedBox(width: 8.0),
                  Text('Deposit using Paydala'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawScreen(balance: 1500),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_downward),
                  //SizedBox(width: 8.0),
                  // SizedBox(
                  //   height: 40.0,
                  //   child: Text('Withdraw using Paydala'),
                  // ),
                  Text('Withdraw using Paydala'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WalletHomePageStatefulWidget extends StatefulWidget {
  const WalletHomePageStatefulWidget({Key? key}) : super(key: key);

  @override
  _WalletHomePageState createState() => _WalletHomePageState();
}

Map<int, int> usdToCoins = {};

class _WalletHomePageState extends State<WalletHomePageStatefulWidget> {
  int balance = 1500;

  void processTransaction(Object txnObject) {
    var txnAmount = 0.0;
    if (txnObject is TransactionResponse) {
      TransactionResponse txnResponse = txnObject;
      for (var txnDetails in txnResponse.txnDetails) {
        if (txnDetails.status == "success") txnAmount += txnDetails.amount;
      }
      print("TransactionResponse: ${txnObject.toJson()}");
    } else if (txnObject is TransactionDetails) {
      TransactionDetails txnDetails = txnObject;
      if (txnDetails.status == "success") txnAmount += txnDetails.amount;
      print("ChannelEvent: ${txnObject.toJson()}");
    } else {
      print("Unknown object type");
    }
    setState(() {
      balance += usdToCoins[txnAmount.toInt()]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Coins $balance',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OperatorDepositScreen(
                              onTransaction: processTransaction,
                            )));
                // MaterialPageRoute(
                //   builder: (context) => PaydalaFlutterWidget(
                //       title: "Deposit using Paydala",
                //       url: "https://flutter.dev",
                //       payload: '{"email" : "john.doe@test.com"}'),
                // ));
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_upward),
                  // SizedBox(width: 8.0),
                  Text('Deposit using Paydala'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawScreen(balance: 1500),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_downward),
                  Text('Withdraw using Paydala'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PaydalaDepositScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit using Paydala'),
      ),
      body: Center(
        child: Text('Paydala Flutter widget for deposit'),
      ),
    );
  }
}

class OperatorDepositScreen extends StatefulWidget {
  final ValueChanged<Object> onTransaction;
  const OperatorDepositScreen({required this.onTransaction});
  // const OperatorDepositScreen({Key? key});

  @override
  _OperatorDepositScreenState createState() => _OperatorDepositScreenState();
}

class _OperatorDepositScreenState extends State<OperatorDepositScreen> {
  int? _selectedAmount;

  final List<Map<String, String>> _amounts = [
    {'label': '10', 'amount': '1000', 'regular_tokens': '10'},
    {'label': '20', 'amount': '2000', 'regular_tokens': '20'},
    {'label': '25', 'amount': '5000', 'regular_tokens': '25'},
    {'label': '50', 'amount': '10000', 'regular_tokens': '50'},
    {'label': '100', 'amount': '20000', 'regular_tokens': '100'},
    {'label': '250', 'amount': '50000', 'regular_tokens': '250'},
  ];

  @override
  void initState() {
    usdToCoins.clear();
    Map<String, String> rowMap;
    for (rowMap in _amounts) {
      usdToCoins[int.parse(rowMap['label']!)] = int.parse(rowMap['amount']!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit using Paydala'),
      ),
      body: SingleChildScrollView(
        child: DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
          columns: [
            DataColumn(label: Text('USD   ')),
            DataColumn(label: Text('Cash Coins ')),
            DataColumn(label: Text('Regular Coins')),
          ],
          rows: [
            for (int index = 0; index < _amounts.length; index++)
              DataRow(
                selected: _selectedAmount == index,
                onSelectChanged: (bool? selected) {
                  setState(() {
                    _selectedAmount = selected! ? index : null;
                  });
                },
                cells: [
                  //DataCell(Text('\$ ${_amounts[index]['label']}')),
                  DataCell(Text(_amounts[index]['label']!)),
                  DataCell(Text(_amounts[index]['amount']!)),
                  DataCell(Text(_amounts[index]['regular_tokens']!)),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
            16, 16, 16, 16), //const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedAmount != null
              ? () {
                  // TODO: Deposit logic
                  var payload = createPayload();
                  if (_selectedAmount != null) {
                    final selectedRow = _amounts[_selectedAmount!];
                    final usdValue = selectedRow['label'];
                    final usdValueDouble = double.parse(usdValue!);
                    payload.predefinedAmount.values = usdValueDouble;
                    // Clipboard.setData(ClipboardData(text: usdValue));
                  } else {
                    payload.predefinedAmount.values = 0;
                    payload.predefinedAmount.isEditable = true;
                  }
                  payload.customerId = '123456';
                  payload.requestId = generateUuid();
                  SignedCreds signedCreds = getSignedCreds(jsonEncode(payload));

                  // payload.predefinedAmount.values = 30;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => // PaydalaDepositScreen()
                          PaydalaFlutterWidget(
                        onTransaction: widget.onTransaction,
                        title: 'Paydala Deposit',
                        url:
                            "https://dev-widget.paydala.com?environment=development",
                        signedCreds: signedCreds,
                      ),
                    ),
                    // PaydalaDepositScreen()));
                  );
                }
              : null,
          child: Text('Deposit'),
        ),
      ),
    );
  }
}

class PaydalaWithdrawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw using Paydala'),
      ),
      body: Center(
        child: Text('Paydala Flutter widget for withdraw'),
      ),
    );
  }
}

class WithdrawScreen extends StatelessWidget {
  final double balance;

  WithdrawScreen({required this.balance});

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: '45');

    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Balance',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Coins ${balance.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Withdraw Coins',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter a number',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  '(equivalent in USD 30)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'To withdraw money through Paydala wallet, you need to log in to the Paydala wallet account in the next step. If you do not have a Paydala wallet account, you are required to register using the same email that you used to deposit. You will not be allowed to withdraw as a guest.',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                String withdrawalAmount =
                    '10'; // get the withdrawal amount from the text field
                String url =
                    "https://dev-widget.paydala.com/?environment=development"; // construct the URL with the withdrawal amount parameter
                showBlockingDialog(context, "Paydala", "Not yet integrated");
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   '/wallet',
                //   (route) => false,
                // );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => // PaydalaWithdrawScreen()
                //         PaydalaFlutterWidget(
                //             title: 'Login & withdraw',
                //             url: url,
                //             payload: '{"email" : "john.doe@test.com"}'),
                //   ),
                //   // PaydalaDepositScreen()));
                // );
              },
              child: Text('Withdraw'),
            ),
          ],
        ),
      ),
    );
  }
}

void showMessageDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // prevent dialog from being dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/wallet',
                (route) => false,
              );
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void showBlockingDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // prevent dialog from being dismissed by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
