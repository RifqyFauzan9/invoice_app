class Bank {
  final String bankName;
  final int accountNumber;
  final String branch;

  Bank({
    required this.bankName,
    required this.accountNumber,
    required this.branch,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    branch: json["branch"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "accountNumber": accountNumber,
    "branch": branch,
  };
}