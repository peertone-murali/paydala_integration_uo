import 'package:flutter/material.dart';
import 'package:op_app_flutter/src/paydala_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WalletHomePage(),
    );
  }
}

class WalletHomePage extends StatelessWidget {
  final int balance = 1500;

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
                        builder: (context) => OperatorDepositScreen()));
                // MaterialPageRoute(
                //   builder: (context) => PaydalaWebView(
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

//{"firstname":"Joe","middlename":"st.","lastname":"smith","customer_id":"1","email":"john","dob":"10/22/2000","ssl4":"3456","street_address":"123 Elm st","address_city":"Big city","address_state":"Tx","address_zip":"56060","address_country":"USA","mobile_ph":"4023345676"}

class User {
  String firstName;
  String middleName;
  String lastName;
  String customerId;
  String email;
  String dob;
  String ssl4;
  String streetAddress;
  String addressCity;
  String addressState;
  String addressZip;
  String addressCountry;
  String mobilePh;

  User(
    this.firstName,
    this.middleName,
    this.lastName,
    this.customerId,
    this.email,
    this.dob,
    this.ssl4,
    this.streetAddress,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.mobilePh,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstname'],
        middleName = json['middlename'],
        lastName = json['lastname'],
        customerId = json['customer_id'],
        email = json['email'],
        dob = json['dob'],
        ssl4 = json['ssl4'],
        streetAddress = json['street_address'],
        addressCity = json['address_city'],
        addressState = json['address_state'],
        addressZip = json['address_zip'],
        addressCountry = json['address_country'],
        mobilePh = json['mobile_ph'];

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'middlename': middleName,
        'lastname': lastName,
        'customer_id': customerId,
        'email': email,
        'dob': dob,
        'ssl4': ssl4,
        'street_address': streetAddress,
        'address_city': addressCity,
        'address_state': addressState,
        'address_zip': addressZip,
        'address_country': addressCountry,
        'mobile_ph': mobilePh,
      };
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

// class OperatorDepositScreen extends StatefulWidget {
//   const OperatorDepositScreen({super.key});

//   @override
//   _OperatorDepositScreenState createState() => _OperatorDepositScreenState();
// }

// class _OperatorDepositScreenState extends State<OperatorDepositScreen> {
//   int? _selectedAmount;

//   List<int> _amounts = [10, 20, 50, 100, 200, 500];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Deposit'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             for (int amount in _amounts)
//               RadioListTile(
//                 title: Text('\$$amount'),
//                 value: amount,
//                 groupValue: _selectedAmount,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedAmount = value;
//                   });
//                 },
//               ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Add logic for depositing selected amount here
//               },
//               child: Text('Deposit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class OperatorDepositScreen extends StatefulWidget {
  const OperatorDepositScreen({Key? key});

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
            DataColumn(label: Text('USD     ')),
            DataColumn(label: Text('Gold Coins ')),
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
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedAmount != null
              ? () {
                  // TODO: Deposit logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaydalaDepositScreen()
                        // PaydalaWebView(
                        //     title: 'Login & withdraw',
                        //     url: url,
                        //     payload: '{"email" : "john.doe@test.com"}'),
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
              onPressed: () {
                String withdrawalAmount =
                    '10'; // get the withdrawal amount from the text field
                String url =
                    'https://example.com/withdraw?amount=$withdrawalAmount'; // construct the URL with the withdrawal amount parameter
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaydalaWithdrawScreen()
                      // PaydalaWebView(
                      //     title: 'Login & withdraw',
                      //     url: url,
                      //     payload: '{"email" : "john.doe@test.com"}'),
                      ),
                  // PaydalaDepositScreen()));
                );
              },
              child: Text('Withdraw'),
            ),
          ],
        ),
      ),
    );
  }
}
