import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class BelajarUploadImagePage extends StatefulWidget {
  const BelajarUploadImagePage({super.key});

  @override
  State<BelajarUploadImagePage> createState() => _BelajarUploadImagePageState();
}

class _BelajarUploadImagePageState extends State<BelajarUploadImagePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const Text("Belum ada gambar"),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 50,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: LivestColors.primaryNormal,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
