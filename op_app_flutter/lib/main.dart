import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:op_app_flutter/src/op_server_api.dart';
import 'package:op_app_flutter/src/paydala_flutter_widget.dart';
import 'package:op_app_flutter/src/payload.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';
import 'package:op_app_flutter/src/signedcreds.dart';

void main() => runApp(MyApp());

// int balance = 0;
// TransactionResponse? txnResponse;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return /* isIOS
        ? CupertinoApp(
            title: 'Wallet App',
            theme: CupertinoThemeData(
              primaryColor: Colors.blue,
            ),
            home: WalletHomePageWidget(),
            routes: {
              '/wallet': (context) => WalletHomePageWidget(),
            },
          )
        : */
        MaterialApp(
      title: 'Wallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalletHomePageWidget(),
      routes: {
        '/wallet': (context) => WalletHomePageWidget(),
      },
    );
  }
}

class WalletHomePageWidget extends StatefulWidget {
  const WalletHomePageWidget({Key? key}) : super(key: key);

  @override
  _WalletHomePageState createState() => _WalletHomePageState();
}

Map<int, int> usdToCoins = {};

class _WalletHomePageState extends State<WalletHomePageWidget> {
  // int balance = 1500;
  static int balance = 0;
  static TransactionResponse? txnResponse;

  void processTransaction(Object txnObject) {
    // var txnAmount = 0.0;
    if (txnObject is TransactionResponse) {
      txnResponse = txnObject;
      // for (var txnDetails in txnResponse.txnDetails) {
      //   if (txnDetails.status == "success") txnAmount += txnDetails.amount;
      // }
      pdPrint("TransactionResponse: ${txnResponse?.toJson()}");
    } else if (txnObject is TransactionDetails) {
      TransactionDetails txnDetails = txnObject;
      if (txnDetails.status == "success") {
        try {
          balance += usdToCoins[txnDetails.amount.toInt()]!;
        } catch (e) {
          pdPrint("Error: $e");
        }
      }
      pdPrint("ChannelEvent: ${txnObject.toJson()}");
    } else {
      pdPrint("Unknown object type");
    }
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
              },
              child: Row(
                children: const [
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
                    builder: (context) =>
                        WithdrawScreen(balance: balance.toDouble()),
                  ),
                );
              },
              child: Row(
                children: const [
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

// class PaydalaDepositScreen extends StatelessWidget {
//   const PaydalaDepositScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Deposit using Paydala'),
//       ),
//       body: Center(
//         child: Text('Paydala Flutter widget for deposit'),
//       ),
//     );
//   }
// }

class OperatorDepositScreen extends StatefulWidget {
  final ValueChanged<Object> onTransaction;
  const OperatorDepositScreen({super.key, required this.onTransaction});
  // const OperatorDepositScreen({Key? key});

  @override
  _OperatorDepositScreenState createState() => _OperatorDepositScreenState();
}

class _OperatorDepositScreenState extends State<OperatorDepositScreen> {
  int? _selectedAmount;

  final List<Map<String, String>> _amounts = [
    {'usd': '10', 'cash_coins': '1000', 'regular_coins': '10'},
    {'usd': '20', 'cash_coins': '2000', 'regular_coins': '20'},
    {'usd': '50', 'cash_coins': '5000', 'regular_coins': '50'},
    {'usd': '100', 'cash_coins': '10000', 'regular_coins': '100'},
    {'usd': '200', 'cash_coins': '20000', 'regular_coins': '200'},
    {'usd': '300', 'cash_coins': '30000', 'regular_coins': '300'},
  ];

  @override
  void initState() {
    usdToCoins.clear();
    Map<String, String> rowMap;
    for (rowMap in _amounts) {
      usdToCoins[int.parse(rowMap['usd']!)] = int.parse(rowMap['cash_coins']!);
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
          columns: const [
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
                  //DataCell(Text('\$ ${_amounts[index]['usd']}')),
                  DataCell(Text(_amounts[index]['usd']!)),
                  DataCell(Text(_amounts[index]['cash_coins']!)),
                  DataCell(Text(_amounts[index]['regular_coins']!)),
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
                    final usdValue = selectedRow['usd'];
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
                      builder: (context) => PaydalaFlutterWidget(
                        onTransaction: widget.onTransaction,
                        title: 'Paydala Deposit',
                        url:
                            "https://dev-widget.paydala.com?environment=development",
                        signedCreds: signedCreds,
                      ),
                    ),
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
  const PaydalaWithdrawScreen({super.key});

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

  const WithdrawScreen({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: '0');

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
                        controller: controller,
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
                  'While withdrawing money through Paydala wallet, the same wallet / identity (email) used during the first deposit will be used.',
                  // 'To withdraw money through Paydala wallet, you need to log in to the Paydala wallet account in the next step. If you do not have a Paydala wallet account, you are required to register using the same email that you used to deposit. You will not be allowed to withdraw as a guest.',
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
