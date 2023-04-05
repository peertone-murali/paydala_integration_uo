import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:op_app_flutter/src/deposit_payload.dart';
import 'package:op_app_flutter/src/op_server_api.dart';
import 'package:op_app_flutter/src/paydala_flutter_widget.dart';
import 'package:op_app_flutter/src/txn_response.dart';
import 'package:op_app_flutter/src/utils.dart';
import 'package:op_app_flutter/src/withdraw_payload.dart';

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
        Wallet App',
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

Map<int, int> usdToCoins = {};
int coinBalance = 0;

class WalletHomePageWidget extends StatefulWidget {
  const WalletHomePageWidget({Key? key}) : super(key: key);

  @override
  _WalletHomePageState createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePageWidget> {
  static TransactionResponse? txnResponse;

  void processTransaction(Object txnObject) {
    if (txnObject is TransactionResponse) {
      txnResponse = txnObject;

      pdPrint("TransactionResponse: ${txnResponse?.toJson()}");
    } else if (txnObject is TransactionDetails) {
      TransactionDetails txnDetails = txnObject;
      if (txnDetails.status == "success") {
        try {
          coinBalance += usdToCoins[txnDetails.amount.toInt()]!;
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
              'Coins $coinBalance',
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
                        WithdrawScreen(balance: coinBalance.toDouble()),
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
                  var payload = createDepositPayload();
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
                  // SignedCreds signedCreds =
                  //     getSignedCreds(jsonEncode(payload), false);

                  // payload.predefinedAmount.values = 30;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaydalaFlutterWidget(
                          onTransaction: widget.onTransaction,
                          title: 'Paydala Deposit',
                          url:
                              "https://dev-widget.paydala.com?environment=development",
                          payload: jsonEncode(payload)),
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

class WithdrawScreen extends StatefulWidget {
  final double balance;

  const WithdrawScreen({super.key, required this.balance});

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  TextEditingController controller = TextEditingController(text: '');
  int withdrawalAmount = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      String text = controller.text;
      if (text.isNotEmpty) {
        try {
          int value = int.parse(text);
          if (value >= 0) {
            withdrawalAmount = value;
            HapticFeedback.mediumImpact();
          }
        } catch (e) {
          withdrawalAmount = 0;
          HapticFeedback.lightImpact();
        }
      } else {
        withdrawalAmount = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Coins ${coinBalance.toStringAsFixed(0)}',
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
                          labelText: 'Enter coins',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text(
                  '(equivalent to USD ${withdrawalAmount / 100})',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'While withdrawing money through Paydala, the wallet with the same identity (email) specified during the first deposit will be used.',
                  // 'To withdraw money through Paydala wallet, you need to log in to the Paydala wallet account in the next step. If you do not have a Paydala wallet account, you are required to register using the same email that you used to deposit. You will not be allowed to withdraw as a guest.',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                if (withdrawalAmount > coinBalance) {
                  showMessageDialog(context, "Paydala", "Insufficient balance");
                  return;
                }
                WithdrawPayload payload = createWithdrawPayload();
                payload.amount = withdrawalAmount / 100;
                payload.requestId = generateUuid();
                sendMoney(payload).then((response) {
                  if (response != null && response.success) {
                    coinBalance -= withdrawalAmount;

                    showMessageDialog(
                        context, "Paydala", "Withdrawal successful");

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/wallet',
                      (route) => false,
                    ); //.then((value) => setState(() {}));
                  } else {
                    showMessageDialog(context, "Paydala", "Withdrawal failed");
                  }
                  // showBlockingDialog(context, "Paydala", "Not yet integrated");
                });
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
              Navigator.pop(context);
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   '/wallet',
              //   (route) => false,
              // );
              return;
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
