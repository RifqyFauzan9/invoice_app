enum InvoiceStatus { booking, lunas, issued, cancel }

extension InvoiceStatusExt on InvoiceStatus {
  String get label {
    switch (this) {
      case InvoiceStatus.booking:
        return 'Booking';
      case InvoiceStatus.lunas:
        return 'Lunas';
      case InvoiceStatus.issued:
        return 'Issued';
      case InvoiceStatus.cancel:
        return 'Cancel';
    }
  }

  String get iconPath {
    switch (this) {
      case InvoiceStatus.booking:
        return 'assets/images/pending_icon.png';
      case InvoiceStatus.lunas:
        return 'assets/images/lunas_icon.png';
      case InvoiceStatus.issued:
        return 'assets/images/hangus_icon.png';
      case InvoiceStatus.cancel:
        return 'assets/images/cancel_icon.png';
    }
  }

  static InvoiceStatus fromString(String value) {
    return InvoiceStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => InvoiceStatus.booking,
    );
  }
}
