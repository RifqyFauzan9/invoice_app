import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/bank_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/setup/bank.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataBankForm extends StatefulWidget {
  const DataBankForm({super.key, required this.mode, required this.oldBank});

  final Bank? oldBank;
  final FormMode mode;

  @override
  State<DataBankForm> createState() => _DataBankFormState();
}

class _DataBankFormState extends State<DataBankForm> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _branchController = TextEditingController();
  final _accountHolderController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.mode == FormMode.edit && widget.oldBank != null) {
      _bankNameController.text = widget.oldBank!.bankName;
      _accountNumberController.text = widget.oldBank!.accountNumber.toString();
      _branchController.text = widget.oldBank!.branch;
      _accountHolderController.text = widget.oldBank!.accountHolder;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
    // Hint Text Style
    TextStyle hintTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPropScreenWidth(25),
            vertical: getPropScreenWidth(60),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    CustomIconButton(
                      icon: Icons.sync,
                      onPressed: () => _resetForm(),
                    ),
                  ],
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Align(
                  alignment: Alignment.center,
                  child: SectionTitleForm(
                    text: widget.mode == FormMode.add
                        ? 'Add Bank Data'
                        : 'Edit Bank Data',
                  ),
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Bank', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _bankNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Bank',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Nomor Rekening', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor Rekening',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Cabang', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _branchController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Cabang Bank',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Atas Nama', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _accountHolderController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Pemegang Akun',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon isi form dengan benar.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: InvoiceColor.primary.color,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _saveBank();
                                }
                              },
                              child: const Text('Submit'),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveBank() async {
    final service = context.read<BankService>();
    final bankName = _bankNameController.text;
    final accountNumber = _accountNumberController.text;
    final branch = _branchController.text;
    final accountHolder = _accountHolderController.text;
    final navigator = Navigator.of(context);
    final bankId = widget.mode == FormMode.edit && widget.oldBank != null
        ? widget.oldBank!.bankId
        : const Uuid().v4();

    setState(() {
      isLoading = true;
    });
    try {
      await service.saveBank(
        bankId: bankId,
        uid: context.read<FirebaseAuthProvider>().profile!.uid!,
        bankName: bankName,
        accountNumber: accountNumber,
        branch: branch,
        accountHolder: accountHolder,
      );
      debugPrint('data bank berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    _bankNameController.clear();
    _accountNumberController.clear();
    _branchController.clear();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _bankNameController.clear();
    _accountNumberController.clear();
    _branchController.clear();
    _accountHolderController.clear();
  }
}
