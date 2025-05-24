import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/services/note_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../static/size_config.dart';
import '../../../../style/colors/invoice_color.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

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
                    'Data Note',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                CustomIconButton(
                  icon: Icons.add,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    ScreenRoute.noteForm.route,
                    arguments: {
                      'mode': FormMode.add,
                      'oldNote': null,
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamProvider<List<Note>>(
                create: (context) => context.read<NoteService>().getNote(
                    context.read<FirebaseAuthProvider>().profile!.uid!),
                initialData: const <Note>[],
                catchError: (context, error) {
                  debugPrint('Error: $error');
                  return [];
                },
                builder: (context, child) {
                  final notes = Provider.of<List<Note>>(context);
                  return notes.isEmpty
                      ? const Center(
                          child: Text('Empty List'),
                        )
                      : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return CustomCard(
                              onCardTapped: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(note.noteName),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Note',
                                            style: TextStyle(
                                              fontSize: getPropScreenWidth(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            note.content,
                                            maxLines: 7,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: getPropScreenWidth(6)),
                                          Text(
                                            'Term Payment',
                                            style: TextStyle(
                                              fontSize: getPropScreenWidth(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            note.termPayment,
                                            maxLines: 7,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              imageLeading: 'assets/images/note_icon.png',
                              title: note.noteName,
                              trailing: PopupMenuButton(
                                iconColor: InvoiceColor.primary.color,
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.pushNamed(context, ScreenRoute.noteForm.route, arguments: {
                                        'mode': FormMode.edit,
                                        'oldNote': note,
                                      });
                                    },
                                    child: Text('Edit Data'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      showDialog(context: context, builder: (context) {
                                        return  AlertDialog(
                                          title: Text(
                                            'Hapus note ${note.noteName}?',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize:
                                                getPropScreenWidth(18)),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<NoteService>()
                                                    .deleteNote(uid: context.read<FirebaseAuthProvider>().profile!.uid!, noteId: note.noteName,);
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
                                      },);
                                    },
                                    child: Text('Hapus Data'),
                                  ),
                                ],
                              )
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
