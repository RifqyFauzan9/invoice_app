import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

class InvoiceForm extends StatefulWidget {
  const InvoiceForm({super.key});

  @override
  State<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceForm> {
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String defaultBank = 'Mandiri';
  final List<String> bankValues = ['Mandiri', 'BCA', 'Other...'];

  void _resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      defaultBank = 'Mandiri';
      _dateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontWeight: FontWeight.bold);

    // Field title style
    TextStyle fieldTitleStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Add Data',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    CustomIconButton(
                      icon: Icons.refresh,
                      onPressed: () => _resetForm(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Travel',
                        style: fieldTitleStyle,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      Text('Nama Travel', style: fieldLabelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(hintText: 'Masukkan nama Travel'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No ID Travel', style: fieldLabelStyle),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(hintText: 'Masukkan No ID'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal', style: fieldLabelStyle),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: _dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050),
                                    );
                                    if (pickedDate != null) {
                                      _dateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Masukkan Tanggal'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Alamat', style: fieldLabelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Alamat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Nomor Telepon', style: fieldLabelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor Telepon',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Email', style: fieldLabelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Data Bank',
                        style: fieldTitleStyle,
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Bank', style: fieldLabelStyle),
                                SizedBox(height: 8),
                                DropdownButtonFormField(
                                  value: defaultBank,
                                  items: bankValues.map((bank) {
                                    return DropdownMenuItem(
                                      value: bank,
                                      child: Text(bank),
                                    );
                                  }).toList(),
                                  onChanged: (bank) {
                                    setState(() {
                                      defaultBank = bank!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('No REK', style: fieldLabelStyle),
                                SizedBox(height: 8),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan No REK',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {}
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
  }
}
