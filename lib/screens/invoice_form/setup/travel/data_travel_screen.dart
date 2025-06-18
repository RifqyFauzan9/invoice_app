import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_invoice_app/model/setup/travel.dart';
import 'package:my_invoice_app/services/travel_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/size_config.dart';

class DataTravelScreen extends StatefulWidget {
  const DataTravelScreen({super.key});

  @override
  State<DataTravelScreen> createState() => _DataTravelScreenState();
}

class _DataTravelScreenState extends State<DataTravelScreen> {
  String searchQuery = '';

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
                    'Data Travel',
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
                      ScreenRoute.travelForm.route,
                      arguments: {
                        'mode': FormMode.add,
                        'oldTravel': null,
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SearchBar(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              elevation: WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              leading: Icon(Icons.search, size: 32, color: Colors.grey),
              hintText: 'Search by Travel Name or CP',
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),
            if (Platform.isIOS) SizedBox(height: SizeConfig.screenHeight * 0.01),
            Expanded(
              child: StreamProvider<List<Travel>>(
                create: (context) => context.read<TravelService>().getTravel(
                    context.read<FirebaseAuthProvider>().profile!.uid!),
                initialData: const <Travel>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                builder: (context, child) {
                  final travels = Provider.of<List<Travel>>(context);
                  final filtered = searchQuery.isEmpty
                      ? travels
                      : travels.where((travel) {
                    final q = searchQuery.toLowerCase();
                    return travel.travelName.toLowerCase().contains(q) || travel.contactPerson.toLowerCase().contains(q);
                  }).toList();

                  return filtered.isEmpty
                      ? const Center(
                          child: Text('Empty List'),
                        )
                      : ListView.builder(
                    padding: Platform.isIOS ? EdgeInsets.zero : null,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final travel = filtered[index];
                            return CustomCard(
                              imageLeading: 'assets/images/travel_icon.png',
                              title: travel.travelName,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    travel.contactPerson,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    travel.travelAddress,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                        ScreenRoute.travelForm.route,
                                        arguments: {
                                          'mode': FormMode.edit,
                                          'oldTravel': travel,
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
                                              'Hapus ${travel.travelName}?',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize:
                                                      getPropScreenWidth(18)),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  context
                                                      .read<TravelService>()
                                                      .deleteTravel(
                                                          uid: context
                                                              .read<
                                                                  FirebaseAuthProvider>()
                                                              .profile!
                                                              .uid!,
                                                          travelId:
                                                              travel.travelId);
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
                              ),
                            );
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
