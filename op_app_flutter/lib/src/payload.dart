class UserTransaction {
  double amount;
  bool canMakeDeposits;

  UserTransaction(this.amount, this.canMakeDeposits);

  UserTransaction.fromJson(Map<String, dynamic> json)
      : amount = json['amount'],
        canMakeDeposits = json['canMakeDeposits'];

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'canMakeDeposits': canMakeDeposits,
      };
}

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
  UserTransaction userTransaction;

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
    this.userTransaction,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        middleName = json['middleName'],
        lastName = json['lastName'],
        customerId = json['customerId'],
        email = json['email'],
        dob = json['dob'],
        ssl4 = json['ssl4'],
        streetAddress = json['streetAddress'],
        addressCity = json['addressCity'],
        addressState = json['addressState'],
        addressZip = json['addressZip'],
        addressCountry = json['addressCountry'],
        mobilePh = json['mobilePh'],
        userTransaction = UserTransaction.fromJson(json['userTransaction']);

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'customerId': customerId,
        'email': email,
        'dob': dob,
        'ssl4': ssl4,
        'streetAddress': streetAddress,
        'addressCity': addressCity,
        'addressState': addressState,
        'addressZip': addressZip,
        'addressCountry': addressCountry,
        'mobilePh': mobilePh,
        'userTransaction': userTransaction.toJson(),
      };
}
