import 'package:flutter/material.dart';
import 'package:my_invoice_app/services/travel_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/size_config.dart';

class DataTravelScreen extends StatefulWidget {
  const DataTravelScreen({super.key});

  @override
  State<DataTravelScreen> createState() => _DataTravelScreenState();
}

class _DataTravelScreenState extends State<DataTravelScreen> {
  final TextEditingController _searchController = TextEditingController();
  List? _allResults;
  List? _resultList;
  String? uid;

  getClientStream(String uid) async {
    var data = await context.read<TravelService>().getTravel(uid);
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text.isNotEmpty) {
      for (var clientSnapshot in _allResults ?? []) {
        var travelName = clientSnapshot['travelName'].toString().toLowerCase();
        if (travelName.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults ?? []);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchedChanged);
  }

  _onSearchedChanged() {
    searchResultList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    uid ??= context.read<FirebaseAuthProvider>().profile?.uid;
    if (uid != null) {
      getClientStream(uid!);
    } else {
      debugPrint('UID Null');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchedChanged);
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        ScreenRoute.travelForm.route,
                        arguments: {
                          'mode': FormMode.add,
                          'oldTravel': null,
                        },
                      ).then((_) {
                        if (uid != null) {
                          getClientStream(uid!);
                        }
                      });
                    }
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SearchBar(
                controller: _searchController,
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                elevation: WidgetStatePropertyAll(0),
                textCapitalization: TextCapitalization.sentences,
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                leading: Icon(Icons.search, size: 32, color: Colors.grey),
                hintText: 'Search...',
                padding: WidgetStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              Expanded(
                child: _resultList == null
                    ? ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            buildCustomCardShimmer(context),
                      )
                    : _resultList!.isEmpty
                        ? const Center(
                            child: Text('Empty List'),
                          )
                        : ListView.builder(
                            itemCount: _resultList!.length,
                            itemBuilder: (context, index) {
                              final travel = _resultList![index];
                              return CustomCard(
                                imageLeading: 'assets/images/travel_icon.png',
                                title: travel['travelName'],
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      travel['contactPerson'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Text(
                                      travel['travelAddress'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
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
                                      onTap: () async {
                                        await Navigator.pushNamed(context,
                                            ScreenRoute.travelForm.route,
                                            arguments: {
                                              'mode': FormMode.edit,
                                              'oldTravel': travel,
                                            }).then((_) {
                                          if (uid != null) {
                                            getClientStream(uid!);
                                          }
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
                                                'Hapus ${travel['travelName']}?',
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
                                                          travelId: travel[
                                                              'travelId'],
                                                        );
                                                    Navigator.pop(context);
                                                    if (uid != null) {
                                                      getClientStream(uid!);
                                                    }
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
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomCardShimmer(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(getPropScreenWidth(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              highlightColor: Colors.blueGrey,
              baseColor: Theme.of(context).colorScheme.surface,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                height: getPropScreenWidth(60),
                width: getPropScreenWidth(60),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surface,
                    highlightColor: Colors.blueGrey,
                    child: Container(
                      width: getPropScreenWidth(100),
                      height: getPropScreenWidth(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: getPropScreenWidth(6)),
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.surface,
                    highlightColor: Colors.blueGrey,
                    child: Container(
                      width: getPropScreenWidth(60),
                      height: getPropScreenWidth(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
