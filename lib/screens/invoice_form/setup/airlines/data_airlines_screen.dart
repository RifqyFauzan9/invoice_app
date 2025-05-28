import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/setup/airline.dart';
import 'package:my_invoice_app/services/airline_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:provider/provider.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/size_config.dart';
import '../../../../widgets/main_widgets/custom_icon_button.dart';
import '../../../../widgets/main_widgets/custom_card.dart';

class DataAirlinesScreen extends StatelessWidget {
  const DataAirlinesScreen({super.key});

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
                    'Data Maskapai',
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
                      ScreenRoute.airlinesForm.route,
                      arguments: {
                        'mode': FormMode.add,
                        'oldAirline': null,
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamProvider<List<Airline>>(
                create: (context) => context.read<AirlineService>().getAirline(
                      context.read<FirebaseAuthProvider>().profile!.uid!,
                    ),
                initialData: const <Airline>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                builder: (context, child) {
                  final airlines = Provider.of<List<Airline>>(context);
                  return airlines.isEmpty
                      ? const Center(
                          child: Text('Empty List'),
                        )
                      : ListView.builder(
                    padding: Platform.isIOS ? EdgeInsets.zero : null,
                          itemCount: airlines.length,
                          itemBuilder: (context, index) {
                            final airline = airlines[index];
                            return CustomCard(
                                imageLeading: 'assets/images/airlines_icon.png',
                                title: airline.airlineName,
                                content: Text(
                                  airline.airlineCode,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                trailing: PopupMenuButton(
                                  iconColor: InvoiceColor.primary.color,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () {
                                        Navigator.pushNamed(context, ScreenRoute.airlinesForm.route, arguments: {
                                          'mode': FormMode.edit,
                                          'oldAirline': airline,
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
                                                'Hapus ${airline.airlineName}?',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                    getPropScreenWidth(18)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<AirlineService>()
                                                        .deleteAirline(
                                                        uid: context
                                                            .read<
                                                            FirebaseAuthProvider>()
                                                            .profile!
                                                            .uid!,
                                                        airlineId:
                                                        airline.airlineId);
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
