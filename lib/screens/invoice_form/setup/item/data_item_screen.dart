import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/setup/item.dart';
import 'package:my_invoice_app/services/item_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:provider/provider.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/form_mode.dart';
import '../../../../static/size_config.dart';
import '../../../../style/colors/invoice_color.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';
import '../../../../widgets/main_widgets/custom_card.dart';

class DataItemScreen extends StatelessWidget {
  const DataItemScreen({super.key});

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
                    'Data Item',
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
                    Navigator.pushNamed(context, ScreenRoute.itemForm.route,
                        arguments: {
                          'mode': FormMode.add,
                          'oldItem': null,
                        });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
                child: StreamProvider<List<Item>>(
              create: (context) => context
                  .read<ItemService>()
                  .getItem(context.read<FirebaseAuthProvider>().profile!.uid!),
              initialData: const <Item>[],
              catchError: (context, error) {
                debugPrint('Error: $error');
                return [];
              },
              builder: (context, child) {
                final items = Provider.of<List<Item>>(context);
                return items.isEmpty
                    ? const Center(
                        child: Text('Empty List'),
                      )
                    : ListView.builder(
                  padding: Platform.isIOS ? EdgeInsets.zero : null,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return CustomCard(
                              imageLeading: 'assets/images/item_icon.png',
                              title: item.itemName,
                              content: Text(item.itemCode),
                              trailing: PopupMenuButton(
                                iconColor: InvoiceColor.primary.color,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ScreenRoute.itemForm.route,
                                          arguments: {
                                            'mode': FormMode.edit,
                                            'oldItem': item,
                                          });
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
                                              'Hapus ${item.itemName}?',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    getPropScreenWidth(18),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<ItemService>()
                                                      .deleteItem(
                                                        uid: context
                                                            .read<
                                                                FirebaseAuthProvider>()
                                                            .profile!
                                                            .uid!,
                                                        itemId: item.itemId,
                                                      );
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
            ))
          ],
        ),
      ),
    );
  }
}
