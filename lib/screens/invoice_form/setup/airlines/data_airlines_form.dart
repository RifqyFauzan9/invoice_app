import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/provider/firebase_auth_provider.dart';
import 'package:my_invoice_app/services/airline_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataAirlinesForm extends StatefulWidget {
  const DataAirlinesForm({
    super.key,
    this.oldAirline,
    required this.mode,
  });

  final Airline? oldAirline;
  final FormMode mode;

  @override
  State<DataAirlinesForm> createState() => _DataAirlinesFormState();
}

class _DataAirlinesFormState extends State<DataAirlinesForm> {
  @override
  void initState() {
    if (widget.mode == FormMode.edit && widget.oldAirline != null) {
      _airlineNameController.text = widget.oldAirline!.airlineName;
      _airlineCodeController.text = widget.oldAirline!.airlineCode;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _airlineNameController = TextEditingController();
  final _airlineCodeController = TextEditingController();
  bool isLoading = false;

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
                    text: widget.mode == FormMode.add ? 'Add Data Maskapai' : 'Edit Data Maskapai',
                  ),
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Maskapai', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _airlineNameController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Maskapai',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama maskapai tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Kode', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _airlineCodeController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kode Maskapai',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode maskapai tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
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
                                  _saveAirline();
                                }
                              },
                              child: const Text('Submit'),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAirline() async {
    final service = context.read<AirlineService>();
    final airlineName = _airlineNameController.text;
    final airlineCode = _airlineCodeController.text;
    final airlineId = widget.mode == FormMode.edit && widget.oldAirline != null
        ? widget.oldAirline!.airlineId
        : Uuid().v4();
    final navigator = Navigator.of(context);

    setState(() {
      isLoading = true;
    });
    try {
      await service.saveAirline(
        airlineId: airlineId,
        uid: context.read<FirebaseAuthProvider>().profile!.uid!,
        airlineName: airlineName,
        airlineCode: airlineCode,
      );
      debugPrint('data airline berhasil disimpan!');
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
    _airlineNameController.clear();
    _airlineCodeController.clear();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _airlineNameController.clear();
    _airlineCodeController.clear();
  }

  @override
  void dispose() {
    _airlineNameController.dispose();
    _airlineCodeController.dispose();
    super.dispose();
  }
}
