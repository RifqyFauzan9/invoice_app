// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_invoice_app/screens/main/home_screen.dart';
// import 'package:my_invoice_app/screens/profile/profile_screen.dart';
// import 'package:my_invoice_app/static/screen_route.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _pageIndex = 0;
//
//   final List<Widget> _pages = [
//     HomeScreen(),
//     const ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_pageIndex],
//       bottomNavigationBar: BottomAppBar(
//         height: 70,
//         color: Theme.of(context).colorScheme.primary,
//         shape: CircularNotchedRectangle(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _pageIndex = 0;
//                 });
//               },
//               icon: Icon(
//                 CupertinoIcons.house_fill,
//               ),
//               color: _pageIndex == 0
//                   ? Theme.of(context).colorScheme.onPrimary
//                   : Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
//             ),
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _pageIndex = _pages.length - 1;
//                 });
//               },
//               icon: Icon(
//                 CupertinoIcons.person_fill,
//               ),
//               color: _pageIndex == _pages.length - 1
//                   ? Theme.of(context).colorScheme.onPrimary
//                   : Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(50),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         onPressed: () {
//           Navigator.pushNamed(context, ScreenRoute.chooseForm.route);
//         },
//         tooltip: 'Add Invoice',
//         child: Icon(
//           CupertinoIcons.add,
//           color: Theme.of(context).colorScheme.onPrimary,
//         ),
//       ),
//     );
//   }
// }
