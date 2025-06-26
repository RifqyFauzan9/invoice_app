import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/provider/profile_provider.dart';
import 'package:my_invoice_app/services/item_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../model/setup/item.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';

class DataItemForm extends StatefulWidget {
  const DataItemForm({
    super.key,
    required this.mode,
    this.oldItem,
  });

  final FormMode mode;
  final Item? oldItem;

  @override
  State<DataItemForm> createState() => _DataItemFormState();
}

class _DataItemFormState extends State<DataItemForm> {
  @override
  void initState() {
    if (widget.mode == FormMode.edit && widget.oldItem != null) {
      _itemNameController.text = widget.oldItem!.itemName;
      _itemCodeController.text = widget.oldItem!.itemCode;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemCodeController = TextEditingController();
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
                    text: widget.mode == FormMode.add
                        ? 'Add Item Data'
                        : 'Edit Item Data',
                  ),
                ),
                SizedBox(height: getPropScreenWidth(15)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Item', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Item',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama item tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text('Kode Item', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _itemCodeController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kode Item',
                          hintStyle: hintTextStyle,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode item tidak boleh kosong';
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
                            ))
                          : FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _saveItem();
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

  void _saveItem() async {
    final service = context.read<ItemService>();
    final itemName = _itemNameController.text;
    final itemCode = _itemCodeController.text;
    final navigator = Navigator.of(context);
    final itemId = widget.mode == FormMode.edit && widget.oldItem != null
        ? widget.oldItem!.itemId
        : Uuid().v4();

    setState(() {
      isLoading = true;
    });
    try {
      await service.saveItem(
        itemId: itemId,
        companyId: context.read<ProfileProvider>().person!.companyId!,
        itemName: itemName,
        itemCode: itemCode,
      );
      debugPrint('data item berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    _itemNameController.clear();
    _itemCodeController.clear();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemCodeController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _itemCodeController.clear();
    _itemNameController.clear();
  }
}
