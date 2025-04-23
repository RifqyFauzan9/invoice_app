import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/services/firebase_firestore_service.dart';
import 'package:my_invoice_app/static/screen_route.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_card.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
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
                  ),
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
              leading: Icon(Icons.search, size: 32, color: Colors.grey),
              hintText: 'Search...',
              padding: WidgetStatePropertyAll(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            Expanded(
                child: StreamProvider<List<Note>>(
              create: (context) =>
                  context.read<FirebaseFirestoreService>().getNote(),
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
                            imageLeading: 'assets/images/note_icon.png',
                            title: note.type,
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.more_vert,
                              ),
                            ),
                          );
                        },
                      );
              },
            ),),
          ],
        ),
      ),
    );
  }
}
