import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_invoice_app/widgets/main_widgets/custom_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;

  void chooseImage() async {
    final getImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (getImage != null) {
        imageFile = File(getImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: 248,
              width: 248,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageFile != null
                  ? FileImage(imageFile!)
                  : AssetImage('assets/images/foto.png'),
                )
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: CustomIconButton(
                icon: Icons.add,
                onPressed: () => chooseImage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
