class Bank {
  final String bankName;
  final int accountNumber;
  final String branch;
  final String accountHolder;

  Bank({
    required this.bankName,
    required this.accountNumber,
    required this.branch,
    required this.accountHolder,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    branch: json["branch"],
    accountHolder: json['accountHolder'],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "accountNumber": accountNumber,
    "branch": branch,
    "accountHolder": accountHolder,
  };
}