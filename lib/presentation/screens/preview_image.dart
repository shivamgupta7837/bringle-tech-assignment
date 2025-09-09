import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class PreviewPage extends StatelessWidget {
  final File imageFile;
  const PreviewPage({super.key, required this.imageFile});

  Future<void> _saveImage(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    String newPath = '${directory!.path}/saved_${DateTime.now().millisecondsSinceEpoch}.png';
    await imageFile.copy(newPath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Image saved at $newPath")),
    );
  }

  Future<void> _shareImage() async {
  await Share.shareXFiles(
    [XFile(imageFile.path)],
    text: 'Check out my filtered photo!',
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.file(imageFile, fit: BoxFit.contain),
          ),
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveImage(context),
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _shareImage,
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
