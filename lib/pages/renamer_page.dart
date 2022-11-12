import 'dart:io';
import 'package:file_renamer/constants.dart';
import 'package:file_renamer/widgets/image_renamer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class RenamerPage extends StatefulWidget {
  final String directory;
  const RenamerPage({super.key, required this.directory});

  @override
  State<RenamerPage> createState() => _RenamerPageState();
}

class _RenamerPageState extends State<RenamerPage> {
  late int currentIndex = 0;
  late String directoryName;
  late List<ImageRenamer> imageRenamers = [];

  @override
  void initState() {
    super.initState();
    directoryName = path.basename(widget.directory);

    // Get all files in directory
    const List<String> validExtensions = ['.png', '.jpg', '.jpeg'];
    List<ImageFile> correctFiles = [];
    List<ImageFile> incorrectFiles = [];
    Directory(widget.directory).listSync().forEach((element) {
      if (element is File) {
        String fileName = path.basename(element.path);

        // Only display images
        if (validExtensions.contains(path.extension(element.path))) {
          // Check if file name is correct (if the directory name is the first part of the file name)
          if (fileName.split(dividingChar)[0] == directoryName) {
            correctFiles.add(ImageFile(file: element, name: fileName));
          } else {
            incorrectFiles.add(ImageFile(file: element, name: fileName));
          }
        }
      }
    });

    // Combine the two lists
    for (var file in [...correctFiles, ...incorrectFiles]) {
      imageRenamers.add(ImageRenamer(imageFile: file));
    }

    currentIndex = correctFiles.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0080FF),
        title: Text(
          'Renaming $directoryName Images [${currentIndex + 1}/${imageRenamers.length}]',
          style: const TextStyle(
            color: Color(0xFFEFEFEF),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF191919),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = currentIndex - 1;
                  if (currentIndex < 0) currentIndex = imageRenamers.length - 1;
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                ),
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(Color(0xFF0080FF)),
              ),
              child: const Icon(Icons.arrow_back),
            ),

            // Current image
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: imageRenamers[currentIndex],
            ),

            // Next Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = (currentIndex + 1) % imageRenamers.length;
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                ),
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(Color(0xFF0080FF)),
              ),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}
