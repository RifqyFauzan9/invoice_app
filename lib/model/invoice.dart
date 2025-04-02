class Invoice {
  final Travel travel;
  final Bank bank;
  final Airlines airlines;
  final List<Item> item;
  final Note note;

  Invoice({
    required this.travel,
    required this.bank,
    required this.airlines,
    required this.item,
    required this.note,
  });
}

class Travel {
  final String travelId;
  final String travelName;
  final String contactPerson;
  final String address;
  final int travelPhoneNumber;
  final String travelEmail;

  Travel({
    required this.travelId,
    required this.travelName,
    required this.contactPerson,
    required this.address,
    required this.travelPhoneNumber,
    required this.travelEmail,
  });
}

class Bank {
  final String bankName;
  final int accountNumber;
  final String branch;

  Bank({
    required this.bankName,
    required this.accountNumber,
    required this.branch,
  });
}

class Airlines {
  final String airlineName;
  final String code;

  Airlines({
    required this.airlineName,
    required this.code,
  });
}

class Item {
  final String itemCode;
  final String itemName;

  Item({
    required this.itemCode,
    required this.itemName,
  });
}

class Note {
  final String type;
  final String note;

  Note({
    required this.type,
    required this.note,
  });
}
