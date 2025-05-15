import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/common/company.dart';

class CompanyProvider extends ChangeNotifier {
  Company? _company;

  Company? get company => _company;

  void setCompany(Company company) {
    _company = company;
    notifyListeners();
  }

  void reset() {
    _company = null;
    notifyListeners();
  }

}