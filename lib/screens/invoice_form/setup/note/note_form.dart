import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_invoice_app/model/setup/note.dart';
import 'package:my_invoice_app/services/note_service.dart';
import 'package:my_invoice_app/static/form_mode.dart';
import 'package:my_invoice_app/static/size_config.dart';
import 'package:my_invoice_app/style/colors/invoice_color.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../provider/firebase_auth_provider.dart';
import '../../../../widgets/invoice_form/section_title_form.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({
    super.key,
    required this.mode,
    this.oldNote,
  });

  final FormMode mode;
  final Note? oldNote;

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  @override
  void initState() {
    if (widget.mode == FormMode.edit && widget.oldNote != null) {
      _noteController.text = widget.oldNote!.content;
      _termController.text = widget.oldNote!.termPayment;
      _noteNameController.text = widget.oldNote!.noteName;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _termController = TextEditingController();
  final _noteNameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Field label style
    TextStyle fieldLabelStyle = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );

    // Hint Text Style
    TextStyle hintTextStyle = GoogleFonts.montserrat(
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: SectionTitleForm(
                    text: widget.mode == FormMode.add
                        ? 'Add Note Data'
                        : 'Edit Note Data',
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Judul Note', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _noteNameController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Judul Note',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Note', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Note',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Term Payment', style: fieldLabelStyle),
                      const SizedBox(height: 4),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        controller: _termController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Term Payment',
                          hintStyle: hintTextStyle,
                        ),
                      ),
                      SizedBox(height: 24),
                      isLoading
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: InvoiceColor.primary.color,
                                size: getPropScreenWidth(30),
                              ),
                            )
                          : FilledButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _saveNote();
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

  void _saveNote() async {
    final service = context.read<NoteService>();
    final note = _noteController.text;
    final termPayment = _termController.text;
    final noteName = _noteNameController.text;
    final navigator = Navigator.of(context);
    final noteId = widget.mode == FormMode.edit && widget.oldNote != null
        ? widget.oldNote!.noteId
        : Uuid().v4();

    setState(() {
      isLoading = true;
    });

    try {
      await service.saveNote(
        noteId: noteId,
        uid: context.read<FirebaseAuthProvider>().profile!.uid!,
        noteName: noteName,
        content: note,
        termPayment: termPayment,
      );
      debugPrint('data note berhasil disimpan!');
      navigator.pop();
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    _noteController.clear();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _noteController.clear();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _termController.dispose();
    super.dispose();
  }
}
