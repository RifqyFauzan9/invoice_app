import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/setup/bank.dart';
import 'package:my_invoice_app/services/bank_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/size_config.dart';

class DataBankScreen extends StatelessWidget {
  const DataBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getPropScreenWidth(25),
          vertical: getPropScreenWidth(60),
        ),
        child: Column(
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
                Container(
                  padding: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Data Bank',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.add,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ScreenRoute.bankForm.route,
                      arguments: {
                        'mode': FormMode.add,
                        'oldBank': null,
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamProvider<List<Bank>>(
                create: (context) => context.read<BankService>().getBank(
                    context.read<FirebaseAuthProvider>().profile!.uid!),
                initialData: const <Bank>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                builder: (context, child) {
                  final banks = Provider.of<List<Bank>>(context);
                  return banks.isEmpty
                      ? const Center(
                          child: Text('Empty List'),
                        )
                      : ListView.builder(
                          itemCount: banks.length,
                          itemBuilder: (context, index) {
                            final bank = banks[index];
                            return CustomCard(
                                imageLeading: 'assets/images/bank_icon.png',
                                title: bank.bankName,
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bank.accountNumber.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Text(
                                      bank.branch,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      bank.accountHolder,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  iconColor: InvoiceColor.primary.color,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          ScreenRoute.bankForm.route,
                                          arguments: {
                                            'mode': FormMode.edit,
                                            'oldBank': bank,
                                          },
                                        );
                                      },
                                      child: Text('Edit Data'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Hapus bank ${bank.bankName}?',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        getPropScreenWidth(18)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<BankService>()
                                                        .deleteBank(
                                                            uid: context
                                                                .read<
                                                                    FirebaseAuthProvider>()
                                                                .profile!
                                                                .uid!,
                                                            bankId:
                                                                bank.bankId);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      color: InvoiceColor
                                                          .error.color,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Tidak'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Hapus Data'),
                                    ),
                                  ],
                                ));
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
