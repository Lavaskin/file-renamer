import 'dart:io';

import 'package:file_renamer/constants.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class ImageRenamer extends StatefulWidget {
  final ImageFile imageFile;
  const ImageRenamer({super.key, required this.imageFile});

  @override
  State<ImageRenamer> createState() => _ImageRenamerState();
}

class _ImageRenamerState extends State<ImageRenamer> {
  @override
  Widget build(BuildContext context) {
    String directoryName = path.basename(widget.imageFile.file.parent.path);
    String fileType = path.extension(widget.imageFile.file.path);
    String fileName = widget.imageFile.name;

    // Set the initial value of the text field to the name without the extension (and remove the directory name)
    String initialValue = fileName
        .split(fileType)[0]
        .replaceAll(directoryName + dividingChar, '');
    TextEditingController textEditingController =
        TextEditingController(text: initialValue);

    void renameFile() {
      String newName = textEditingController.text;
      if (newName != '') {
        String newPath = path.join(widget.imageFile.file.parent.path,
            '$directoryName$dividingChar$newName$fileType');

        // Check if file already exists
        if (File(newPath).existsSync()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File already exists!'),
            ),
          );
        } else {
          widget.imageFile.file.renameSync(newPath);
          setState(() {
            widget.imageFile.name =
                '$directoryName$dividingChar$newName$fileType';
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a new name!'),
          ),
        );
      }
    }

    return Column(
      children: [
        Column(
          children: [
            // Image Name/Display
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    fileName,
                    style: subtextStyle,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 300,
                      maxHeight: MediaQuery.of(context).size.height - 300),
                  child: Image.file(
                    widget.imageFile.file,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),

            // Renamer Text Field
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$directoryName$dividingChar',
                    style: subtextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    child: SizedBox(
                      width: 300,
                      child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'New Name...',
                          border: OutlineInputBorder(),
                        ),
                        style: subtextStyle,
                      ),
                    ),
                  ),
                  Text(
                    fileType,
                    style: subtextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ElevatedButton(
                      onPressed: renameFile,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color(0xFF0080FF)),
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

TextStyle subtextStyle = const TextStyle(
  color: Color(0xFFEFEFEF),
  fontSize: 24,
);
