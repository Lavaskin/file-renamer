import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_renamer/pages/renamer_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191919),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: Text(
                'Choose a folder to get started',
                style: TextStyle(fontSize: 48, color: Color(0xFFEFEFEF)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Open directory picker
                String? directory =
                    await FilePicker.platform.getDirectoryPath();

                // If directory is not null, navigate to renamer_page
                if (directory == null) return;

                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RenamerPage(
                      directory: directory,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                ),
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(Color(0xFF0080FF)),
              ),
              child: const Text(
                'Select Folder',
                style: TextStyle(fontSize: 32, color: Color(0xFFEFEFEF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
